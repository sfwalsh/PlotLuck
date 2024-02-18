//
//  AlertError.swift
//  PlotLuck
//
//  Created by Stephen Walsh on 18/02/2024.
//

import Foundation

struct AlertError: LocalizedError {
    var errorDescription: String?
    var recoverySuggestion: String?
    
    init(error: Error?) {
        // handles LocalizedError to handle app domain errors
        if let localizedError = error as? LocalizedError {
            self.errorDescription = localizedError.errorDescription
            self.recoverySuggestion = localizedError.recoverySuggestion
        } else {
            // handles generic errors to handle system level errors
            self.errorDescription = error?.localizedDescription
        }
    }
}
