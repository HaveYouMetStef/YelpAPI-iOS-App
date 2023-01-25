//
//  ErrorController.swift
//  Unit 4 Yelp API Project
//
//  Created by Stef Castillo on 1/13/23.
//

import Foundation

enum NetworkError: Error, LocalizedError {
    case badBaseURL
    case badBuiltURL
    case invalidData(String)
    
    var errorDescription: String? {
        switch self {
        case .badBaseURL:
            return NSLocalizedString("Issue with base URL.", comment: "")
            
        case .badBuiltURL:
            return NSLocalizedString("Issue with URL.", comment: "")
            
        case .invalidData:
            return NSLocalizedString("Issue with data from API call.", comment: "")
        }
    }
}
