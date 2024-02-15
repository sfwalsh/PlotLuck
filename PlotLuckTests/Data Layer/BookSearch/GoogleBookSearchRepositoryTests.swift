//
//  GoogleBookSearchRepositoryTests.swift
//  PlotLuckTests
//
//  Created by Stephen Walsh on 15/02/2024.
//

import Foundation
import XCTest
@testable import PlotLuck

final class GoogleBookSearchRepositoryTests: XCTestCase {

    var repository: GoogleBookSearchRepository!
    var mockDatasource: MockBookSearchDatasource!
    
    override func setUp() {
        super.setUp()
        mockDatasource = MockBookSearchDatasource()
        repository = GoogleBookSearchRepository(datasource: mockDatasource)
    }

    func testFetch_Successful() async throws {
        // Given
        let searchText = "Test"
        let expectedResults = [
            BookSearchResult(
                author: "The Unknown Craftsman", title: "Soetsu Yanagi", isbn: "9780870111846"
            )
        ]
        mockDatasource.fetchResult = expectedResults
        
        // When
        let fetchedResults = try await repository.fetch(forSearchText: searchText)
        
        // Then
        XCTAssertEqual(mockDatasource.fetchCallCount, 1, "Fetch function should be called once")
        XCTAssertEqual(mockDatasource.searchText, searchText, "Search text should match the expected value")
        XCTAssertEqual(fetchedResults, expectedResults, "Fetched results should match the expected results")
    }
}
