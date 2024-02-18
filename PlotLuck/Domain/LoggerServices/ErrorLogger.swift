//
//  ErrorLogger.swift
//  PlotLuck
//
//  Created by Stephen Walsh on 13/02/2024.
//

import Foundation

// Wrapper class to log errors to a third party service like Crashlytics

protocol ErrorLogger {
    func log(for error: Error)
}
