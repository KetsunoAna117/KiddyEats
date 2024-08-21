//
//  OnboardingDatePicker.swift
//  KiddyEatsApp
//
//  Created by Hans Arthur Cupiterson on 21/08/24.
//

import SwiftUI

struct KiddyEatsDatePicker: View {
    var title: String?
    var placeholder: Date?
    var dateRange: ClosedRange<Date>?
    @Binding var date: Date
    
    @State private var showDatePicker: Bool = false
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd, yyyy"
        return formatter
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Section {
                ZStack {
                    Text(dateFormatter.string(from: date))
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding()
                        .onTapGesture {
                            showDatePicker = true
                        }
                        .sheet(isPresented: $showDatePicker, content: {
                            VStack {
                                Text("Select your baby date of birth")
                                DatePicker(
                                    "Select Date of Birth",
                                    selection: $date,
                                    in: dateRange ?? Date.distantPast...Date(),
                                    displayedComponents: .date
                                )
                                    .datePickerStyle(.graphical)
                                    .labelsHidden()
                                    .presentationDetents([.height(500)])
                                Button {
                                    showDatePicker = false
                                } label: {
                                    Text("Done")
                                }
                                .buttonStyle(KiddyEatsProminentButtonStyle())
                                .padding(.horizontal, 30)
                            }
                        })
                    
                    
                }
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundStyle(Color.white)
                )

            } header: {
                if let title = title {
                    Text(title)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.greenPrimary)
                }
            }

        }
    }
}
