//
//  FetchBooksUseCaseTests.swift
//  PlotLuckTests
//
//  Created by Stephen Walsh on 14/02/2024.
//

import XCTest
@testable import PlotLuck

final class FetchBooksUseCaseTests: XCTestCase {
    
    func testFetchBooksUseCase_Success() async {
        // Given
        let repository = MockBookSearchRepository()
        repository.fetchResult = [
            .init(author: "Author", title: "Book", isbn: "1234")
        ]
        let useCase = FetchBooksUseCase(repository: repository)
        
        // When
        let searchTerm = "haruki murakami"
        let result = await useCase.execute(for: .init(searchText: searchTerm))
        
        // Then
        switch result {
        case .success(let results):
            XCTAssertEqual(repository.fetchResult, results, "results returned should be identical to those returned from the repository layer")
            XCTAssertEqual(repository.fetchSearchText, searchTerm, "search text string should be equal to that passed to the use case")
        case .failure:
            XCTFail("fetching should not fail")
        }
    }
    
    func testFetchBooksUseCase_Failure() async {
        // Given
        let repository = MockBookSearchRepository()
        repository.fetchResult = [
            .init(author: "Author", title: "Book", isbn: "1234")
        ]
        let useCase = FetchBooksUseCase(repository: repository)
        
        // When
        let searchTerm = "haruki murakami"
        repository.errorValue = MockError(errorDescription: "Could not Fetch Book Search Results")
        let result = await useCase.execute(for: .init(searchText: searchTerm))
        
        // Then
        switch result {
        case .success:
            XCTFail("fetching items should fail")
        case .failure(let error):
            XCTAssertEqual(error.localizedDescription, "Could not Fetch Book Search Results", "Error should match")
        }
    }
}
