//
//  UpdateReadingListItemUseCaseTests.swift
//  PlotLuckTests
//
//  Created by Stephen Walsh on 13/02/2024.
//

import Foundation

import XCTest
import SwiftData
@testable import PlotLuck

final class UpdateReadingListItemUseCaseTests: XCTestCase {
    
    private var modelContainer: ModelContainer?
    
    override func setUp() async throws {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        self.modelContainer = try ModelContainer(for: ReadingListItem.self, Book.self, configurations: config)
    }
    
    func testUpdateReadingListItem_Success() async {
        // Given
        let repository = MockReadingListRepository()
        let useCase = UpdateReadingListItemUseCase(repository: repository)
        let item = ReadingListItem(
            book: .init(
                title: "Aladdin",
                author: "Scheherazade",
                isbn: "9781784877996"
            ),
            status: .unread
        )
        
        // When
        let update = ReadingListUpdateModel(
            itemToUpdate: item,
            updateType: .bookTitle(title: "Arabian Nights")
        )
        let result = await useCase.execute(for: update)
        
        // Then
        switch result {
        case .success:
            XCTAssertEqual(repository.updateModelValue!, update)
        case .failure:
            XCTFail("updating item should not fail")
        }
    }
    
    func testUpdateReadingListItem_Failure() async {
        // Given
        let repository = MockReadingListRepository()
        let useCase = UpdateReadingListItemUseCase(repository: repository)
        let item = ReadingListItem(
            book: .init(
                title: "Aladdin",
                author: "Scheherazade",
                isbn: "9781784877996"
            ),
            status: .unread
        )
        
        // When
        let update = ReadingListUpdateModel(
            itemToUpdate: item,
            updateType: .bookTitle(title: "Arabian Nights")
        )
        repository.errorValue = MockError(errorDescription: "Could not update Reading List Item")

        let result = await useCase.execute(for: update)
        
        // Then
        switch result {
        case .success:
            XCTFail("Updating item should fail")
        case .failure(let error):
            XCTAssertEqual(error.localizedDescription, "Could not update Reading List Item", "Error should match")
        }
    }
}
