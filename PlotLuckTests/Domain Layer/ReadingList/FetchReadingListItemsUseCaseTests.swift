//
//  FetchReadingListItemsUseCaseTests.swift
//  PlotLuckTests
//
//  Created by Stephen Walsh on 13/02/2024.
//

import Foundation

import XCTest
import SwiftData
@testable import PlotLuck

final class FetchReadingListItemsUseCaseTests: XCTestCase {
    
    private var modelContainer: ModelContainer?
    
    override func setUp() async throws {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        self.modelContainer = try ModelContainer(for: ReadingListItem.self, Book.self, configurations: config)
    }
    
    func testFetchReadingListItems_Success() async {
        // Given
        let repository = MockReadingListRepository()
        let items = [
            ReadingListItem(
                book: .init(title: "The Three Body Problem", author: "Cixin Liu", isbn: "1234", imageURLString: nil),
                status: .finished
            )
        ]
        repository.fetchItemsValue = items
        let useCase = FetchReadingListItemsUseCase(repository: repository)
        
        // When
        let result = await useCase.execute()
        
        // Then
        switch result {
        case .success:
            XCTAssertEqual(repository.fetchItemsValue, items)
        case .failure:
            XCTFail("fetch reading list should not fail")
        }
    }
    
    func testFetchReadingListItems_Failure() async {
        // Given
        let repository = MockReadingListRepository()
        let useCase = FetchReadingListItemsUseCase(repository: repository)
        repository.errorValue = MockError(errorDescription: "Could not fetch Reading List")
        
        // When
        let result = await useCase.execute()
        
        // Then
        switch result {
        case .success:
            XCTFail("fetch items should fail")
        case .failure(let error):
            XCTAssertEqual(error.localizedDescription, "Could not fetch Reading List", "Error should match")
        }
    }
}
