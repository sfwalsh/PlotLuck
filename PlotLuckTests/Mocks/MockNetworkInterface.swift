//
//  MockNetworkInterface.swift
//  PlotLuckTests
//
//  Created by Stephen Walsh on 15/02/2024.
//

import Foundation
@testable import PlotLuck

// Mock objects for testing
final class MockNetworkInterface: NetworkInterface {
    
    var errorValue: Error?
    var fetchDataReturnValue: Any?
    func fetchData<T>(with request: URLRequest) async throws -> T where T : Decodable {
        if let error = errorValue {
            throw error
        }
        
        return fetchDataReturnValue as! T
    }
}
