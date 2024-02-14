//
//  RemoveReadingListItemUseCaseTests.swift
//  PlotLuckTests
//
//  Created by Stephen Walsh on 13/02/2024.
//

import XCTest
import SwiftData
@testable import PlotLuck

final class RemoveReadingListItemUseCaseTests: XCTestCase {
    
    private var modelContainer: ModelContainer?
    
    override func setUp() async throws {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        self.modelContainer = try ModelContainer(for: ReadingListItem.self, Book.self, configurations: config)
    }
    
    func testRemoveReadingListItem_Success() async {
        // Given
        let repository = MockReadingListRepository()
        let useCase = RemoveReadingListItemUseCase(repository: repository)
        
        let item = ReadingListItem(
            book: .init(
                title: "Hyperion",
                author: "Dan K. Simmons",
                isbn: "9781784877996"
            ),
            status: .finished
        )
        
        // When
        let result = await useCase.execute(for: item)
        
        // Then
        switch result {
        case .success:
            XCTAssertEqual(repository.removedItemValue, item)
        case .failure:
            XCTFail("removing item should not fail")
        }
    }
    
    func testRemoveReadingListItem_Failure() async {
        // Given
        let repository = MockReadingListRepository()
        let useCase = RemoveReadingListItemUseCase(repository: repository)
        let item = ReadingListItem(
            book: .init(
                title: "Hyperion",
                author: "Dan K. Simmons",
                isbn: "9781784877996"
            ),
            status: .finished
        )
        
        repository.errorValue = MockError(errorDescription: "Could not remove Reading List Item")
        
        // When
        let result = await useCase.execute(for: item)
        
        // Then
        switch result {
        case .success:
            XCTFail("Adding item should fail")
        case .failure(let error):
            XCTAssertEqual(error.localizedDescription, "Could not remove Reading List Item", "Error should match")
        }
    }
}
