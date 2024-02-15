//
//  MockURLBuilder.swift
//  PlotLuckTests
//
//  Created by Stephen Walsh on 15/02/2024.
//

import Foundation
@testable import PlotLuck

final class MockURLBuilder: URLBuilder {
    
    var errorValue: Error?
    func buildBookSearchURL(for searchTerm: String) throws -> URL {
        
        if let error = errorValue {
            throw error
        }

        return URL(string: "https://Google.com")!
    }
}
