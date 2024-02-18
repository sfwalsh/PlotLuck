//
//  MockBookSearchDatasource.swift
//  PlotLuckTests
//
//  Created by Stephen Walsh on 15/02/2024.
//

import Foundation
@testable import PlotLuck

final class MockBookSearchDatasource: BookSearchDatasource {
    
    var fetchCallCount = 0
    var searchText: String?
    var fetchResult: [BookSearchResult] = []
    
    func fetch(for searchText: String) async throws -> [BookSearchResult] {
        fetchCallCount += 1
        self.searchText = searchText
        return fetchResult
    }
}
