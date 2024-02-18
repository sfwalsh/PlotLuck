//
//  AddReadingListItemUseCaseTests.swift
//  PlotLuckTests
//
//  Created by Stephen Walsh on 12/02/2024.
//

import XCTest
import SwiftData
@testable import PlotLuck

final class AddReadingListItemUseCaseTests: XCTestCase {
    
    private var modelContainer: ModelContainer?
    
    override func setUp() async throws {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        self.modelContainer = try ModelContainer(for: ReadingListItem.self, Book.self, configurations: config)
    }
    
    func testAddReadingListItem_Success() async {
        // Given
        let repository = MockReadingListRepository()
        let useCase = AddReadingListItemUseCase(repository: repository)
        let item = ReadingListItem(
            book: .init(
                title: "Norweigan Wood",
                author: "Haruki Murakami",
                isbn: "9781784877996", 
                imageURLString: nil
            ),
            status: .unread
        )
        
        // When
        let result = await useCase.execute(for: item)
        
        // Then
        switch result {
        case .success:
            XCTAssertEqual(repository.didAddItemValue, item)
        case .failure:
            XCTFail("Adding item should not fail")
        }
    }
    
    func testAddReadingListItem_Failure() async {
        // Given
        let repository = MockReadingListRepository()
        let useCase = AddReadingListItemUseCase(repository: repository)
        let item = ReadingListItem(
            book: .init(
                title: "Norweigan Wood",
                author: "Haruki Murakami",
                isbn: "9781784877996", 
                imageURLString: nil
            ),
            status: .unread
        )
        
        repository.errorValue = MockError(errorDescription: "Could not add Reading List Item")
        
        // When
        let result = await useCase.execute(for: item)
        
        // Then
        switch result {
        case .success:
            XCTFail("Adding item should fail")
        case .failure(let error):
            XCTAssertEqual(error.localizedDescription, "Could not add Reading List Item", "Error should match")
        }
    }
}
