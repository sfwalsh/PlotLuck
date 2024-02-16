//
//  MockErrorLogger.swift
//  PlotLuckTests
//
//  Created by Stephen Walsh on 16/02/2024.
//

import Foundation
@testable import PlotLuck

final class MockErrorLogger: ErrorLogger {
    
    var logCalled = false
    
    func log(for error: Error) {
        logCalled = true
    }
}
