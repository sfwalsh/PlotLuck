//
//  MockBookSearchRepository.swift
//  PlotLuckTests
//
//  Created by Stephen Walsh on 14/02/2024.
//

import Foundation

@testable import PlotLuck

final class MockBookSearchRepository: BookSearchRepository {
    
    var errorValue: Error?
    var fetchResult: [BookSearchResult] = []
    var fetchSearchText: String?
    
    func fetch(forSearchText searchText: String) async throws -> [PlotLuck.BookSearchResult] {
        fetchSearchText = searchText
        if let error = errorValue {
            throw error
        } else {
            return fetchResult
        }
    }
}
