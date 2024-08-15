//
//  AIService.swift
//  NotesForHabits
//
//  Created by Arya Adyatma on 09/07/24.
//

import Foundation
import Combine
import UIKit

let aiUser = "babymealapp-user"

enum FakeAPIKey: String {
    case GPT4o = "app-nZejRKIvCLCPLae2pxNTUESN"
}

enum AIStatus: String {
    case idle = "Idle"
    case compressingImage = "Compressing Image"
    case uploadingImage = "Uploading Image"
    case processingImage = "Processing Image"
    case preparingQuery = "Preparing Query"
    case gettingResponse = "Getting Response from AI"
    case processingResponse = "Processing AI Response"
    case error = "Error Occurred"
}

class AIService: ObservableObject {
    var llmKey: String
    var isConversation: Bool
    var apiEndpoint: String
    
    init(identifier: String, isConversation: Bool, apiEndpoint: String = "https://api.dify.ai") {
        self.llmKey = identifier
        self.isConversation = isConversation
        self.apiEndpoint = apiEndpoint
    }
    
    @Published var aiResponse: String = ""
    @Published var aiStatus: AIStatus = .idle
    
    var cancellables = Set<AnyCancellable>()
    
    private var conversationId = ""
    private var currentTask: AnyCancellable?
    
    func cancel() {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
    }
    
    func sendMessage(query: String, uiImage: UIImage?) -> String {
        // Set initial state
        aiResponse = ""
        aiStatus = .preparingQuery
        
        // Define a helper method to handle completion
        func handleCompletion(_ completion: Subscribers.Completion<Error>, response: String) -> String {
            switch completion {
            case .finished:
                aiStatus = .idle
            case .failure(let error):
                aiStatus = .error
                return "Error: \(error.localizedDescription)"
            }
            return response
        }
        
        // Create a dispatch group to wait for the async work to complete
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        
        var finalResponse: String = ""
        
        // Process the message
        if let image = uiImage {
            uploadImage(image: image)
                .flatMap { fileId in
                    self.sendChatMessage(query: query, fileId: fileId)
                }
                .sink(
                    receiveCompletion: { completion in
                        finalResponse = handleCompletion(completion, response: self.aiResponse)
                        dispatchGroup.leave()
                    },
                    receiveValue: { response in
                        finalResponse = response
                    }
                )
                .store(in: &cancellables)
        } else {
            sendChatMessage(query: query, fileId: nil)
                .sink(
                    receiveCompletion: { completion in
                        finalResponse = handleCompletion(completion, response: self.aiResponse)
                        dispatchGroup.leave()
                    },
                    receiveValue: { response in
                        finalResponse = response
                    }
                )
                .store(in: &cancellables)
        }
        
        // Wait for the async work to complete
        dispatchGroup.wait()
        
        return finalResponse
    }
    
    func sendMessageStreaming(query: String, uiImage: UIImage?, onToken: @escaping (String) -> Void) async throws {
        aiResponse = ""
        aiStatus = .preparingQuery
        
        var request = try await prepareStreamingRequest(query: query, uiImage: uiImage)
        
        aiStatus = .gettingResponse
        
        let (dataStream, _) = try await URLSession.shared.bytes(for: request)
        
        for try await line in dataStream.lines {
            if line.hasPrefix("data:") {
                let jsonData = line.dropFirst(5).data(using: .utf8) ?? Data()
                if let json = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any],
                   let event = json["event"] as? String,
                   event == "message",
                   let token = json["answer"] as? String {
                    onToken(token)
                    aiResponse += token
                }
            }
        }
        
        aiStatus = .idle
    }
    
    private func prepareStreamingRequest(query: String, uiImage: UIImage?) async throws -> URLRequest {
        guard let url = URL(string: "\(apiEndpoint)/v1/chat-messages") else {
            throw NSError(domain: "AIService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(llmKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        var files: [[String: Any]] = []
        if let image = uiImage {
            let fileId = try await uploadImage(image: image)
            files.append(["type": "image", "transfer_method": "local_file", "upload_file_id": fileId])
        }
        
        let body: [String: Any] = [
            "inputs": [:],
            "query": query,
            "response_mode": "streaming",
            "conversation_id": conversationId,
            "user": aiUser,
            "files": files
        ]
        
        request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        
        return request
    }
    
    func sendMessagePub(query: String, uiImage: UIImage?) -> AnyPublisher<String, Error> {
        aiResponse = ""
        aiStatus = .preparingQuery
        
        return Future<String, Error> { [weak self] promise in
            guard let self = self else {
                promise(.failure(NSError(domain: "AIService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Self is nil"])))
                return
            }
            
            let messagePublisher: AnyPublisher<String, Error>
            
            if let image = uiImage {
                messagePublisher = self.uploadImage(image: image)
                    .flatMap { fileId in
                        self.sendChatMessage(query: query, fileId: fileId)
                    }
                    .eraseToAnyPublisher()
            } else {
                messagePublisher = self.sendChatMessage(query: query, fileId: nil)
            }
            
            messagePublisher
                .sink(
                    receiveCompletion: { completion in
                        if case .failure(let error) = completion {
                            self.aiStatus = .error
                            promise(.failure(error))
                        }
                    },
                    receiveValue: { response in
                        self.aiStatus = .idle
                        promise(.success(response))
                    }
                )
                .store(in: &self.cancellables)
        }
        .eraseToAnyPublisher()
    }
    
    private func sendChatMessage(query: String, fileId: String?) -> AnyPublisher<String, Error> {
        guard let url = URL(string: "\(apiEndpoint)/v1/chat-messages") else {
            return Fail(error: NSError(domain: "AIService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(llmKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        var files: [[String: Any]] = []
        if let fileId = fileId {
            files.append([
                "type": "image",
                "transfer_method": "local_file",
                "upload_file_id": fileId
            ])
        }
        
        let body: [String: Any] = [
            "inputs": [:],
            "query": query,
            "response_mode": "blocking",
            "conversation_id": conversationId,
            "user": aiUser,
            "files": files
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        
        aiStatus = .gettingResponse
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { data, response -> Data in
                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    self.aiStatus = .error
                    throw NSError(domain: "AIService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Server error"])
                }
                return data
            }
            .decode(type: LLMBlockingResponse.self, decoder: JSONDecoder())
            .map { [weak self] blockingResponse -> String in
                self?.aiStatus = .processingResponse
                self?.handleBlockingResponse(blockingResponse)
                return self?.aiResponse ?? ""
            }
            .eraseToAnyPublisher()
    }
    
    private func uploadImage(image: UIImage) -> AnyPublisher<String, Error> {
        guard let url = URL(string: "\(apiEndpoint)/v1/files/upload") else {
            return Fail(error: NSError(domain: "AIService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(llmKey)", forHTTPHeaderField: "Authorization")
        
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        aiStatus = .compressingImage
        let maxSize = 1 * 512 * 1024 // 512 KB
        let resizedImage = resizeImage(image: image, maxSize: maxSize) ?? image
        guard let imageData = resizedImage.jpegData(compressionQuality: 0.9) else {
            aiStatus = .error
            return Fail(error: NSError(domain: "AIService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to get image data"])).eraseToAnyPublisher()
        }
        
        var body = Data()
        
        // Append file data
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"image.jpg\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        body.append(imageData)
        body.append("\r\n".data(using: .utf8)!)
        
        // Append user data
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"user\"\r\n\r\n".data(using: .utf8)!)
        body.append("\(aiUser)\r\n".data(using: .utf8)!)
        
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = body
        
        aiStatus = .uploadingImage
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { data, response -> Data in
                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    self.aiStatus = .error
                    throw NSError(domain: "AIService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Server error"])
                }
                return data
            }
            .tryMap { data -> String in
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let fileId = json["id"] as? String {
                    self.aiStatus = .processingImage
                    return fileId
                } else {
                    self.aiStatus = .error
                    throw NSError(domain: "AIService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid JSON format"])
                }
            }
            .eraseToAnyPublisher()
    }
    
    private func resizeImage(image: UIImage, maxSize: Int) -> UIImage? {
        var resizedImage = image
        let compression: CGFloat = 0.9
        guard var imageData = resizedImage.jpegData(compressionQuality: compression) else { return nil }
        
        while imageData.count > maxSize {
            let newSize = CGSize(width: resizedImage.size.width * 0.95, height: resizedImage.size.height * 0.95)
            UIGraphicsBeginImageContext(newSize)
            resizedImage.draw(in: CGRect(origin: .zero, size: newSize))
            resizedImage = UIGraphicsGetImageFromCurrentImageContext() ?? resizedImage
            UIGraphicsEndImageContext()
            
            if let newImageData = resizedImage.jpegData(compressionQuality: compression) {
                imageData = newImageData
            }
        }
        
        return resizedImage
    }
    
    private func handleBlockingResponse(_ blockingResponse: LLMBlockingResponse) {
        if blockingResponse.event == "message" {
            aiResponse += blockingResponse.answer ?? ""
        }
        if conversationId.isEmpty && isConversation {
            conversationId = blockingResponse.conversation_id ?? ""
        }
        aiStatus = .idle
    }
    
    func resetConversation() {
        conversationId = ""
        aiStatus = .idle
    }
    
    func cancelCurrentTask() {
        currentTask?.cancel()
        currentTask = nil
        aiStatus = .idle
    }
}

// Define the blocking response model
struct LLMBlockingResponse: Decodable {
    let event: String
    let message_id: String?
    let conversation_id: String?
    let answer: String?
    let created_at: Int?
}

// Extension to convert Publisher to async/await
extension Publisher {
    func async() async throws -> Output {
        try await withCheckedThrowingContinuation { continuation in
            var cancellable: AnyCancellable?
            cancellable = self.sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                    cancellable?.cancel()
                },
                receiveValue: { value in
                    continuation.resume(returning: value)
                    cancellable?.cancel()
                }
            )
        }
    }
}
