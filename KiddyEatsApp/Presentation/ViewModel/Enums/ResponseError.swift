//
//  ResponseError.swift
//  KiddyEatsApp
//
//  Created by Hans Arthur Cupiterson on 19/08/24.
//

import Foundation

enum ResponseError: Error {
    case failed(message: String)
    case notFound(message: String)
}
