//
//  ReadingListRepositoryTests.swift
//  PlotLuckTests
//
//  Created by Stephen Walsh on 15/02/2024.
//

import Foundation
import XCTest
import SwiftData
@testable import PlotLuck

@MainActor
final class DefaultReadingListRepositoryTests: XCTestCase {
    
    private var modelContainer: ModelContainer!
    private var modelContext: ModelContext!
    
    var repository: DefaultReadingListRepository!
    var mockDatasource: MockReadingListDatasource!

    override func setUpWithError() throws {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        modelContainer = try ModelContainer(for: ReadingListItem.self, Book.self, configurations: config)
        // force unwrapping here only due to it being the test target
        modelContext = modelContainer!.mainContext
        
        mockDatasource = MockReadingListDatasource()
        repository = DefaultReadingListRepository(datasource: mockDatasource)
    }

    func testAddItem_Successful() async throws {
        // Given
        let newItem = createDummyReadingListItem()
        
        // When
        try await repository.addItem(newItem)
        
        // Then
        XCTAssertEqual(mockDatasource.addItemCallCount, 1, "Add item function should be called once")
        XCTAssertEqual(mockDatasource.addedItem, newItem, "Added item should match the expected item")
    }
    
    func testUpdateItem_Successful() async throws {
        // Given
        let itemToUpdate = createDummyReadingListItem()
        let updateModel = ReadingListUpdateModel(itemToUpdate: itemToUpdate, updateType: .readingStatus(.finished))
        
        // When
        try await repository.update(updateModel: updateModel)
        
        // Then
        XCTAssertEqual(mockDatasource.updateCallCount, 1, "Update function should be called once")
        XCTAssertEqual(mockDatasource.updatedModel, updateModel, "Updated model should match the expected model")
    }
    
    func testRemoveItem_Successful() async throws {
        // Given
        let itemToRemove = createDummyReadingListItem()
        
        // When
        try await repository.removeItem(itemToRemove)
        
        // Then
        XCTAssertEqual(mockDatasource.removeItemCallCount, 1, "Remove item function should be called once")
        XCTAssertEqual(mockDatasource.removedItem, itemToRemove, "Removed item should match the expected item")
    }
    
    func testFetchItems_Successful() async throws {
        // Given
        let expectedItems = [
            createDummyReadingListItem()
        ]
        mockDatasource.fetchItemsResult = expectedItems
        
        // When
        let fetchedItems = try await repository.fetchItems()
        
        // Then
        XCTAssertEqual(mockDatasource.fetchItemsCallCount, 1, "Fetch items function should be called once")
        XCTAssertEqual(fetchedItems, expectedItems, "Fetched items should match the expected items")
    }
}

// MARK: Dummy helpers

extension DefaultReadingListRepositoryTests {
    
    private func createDummyReadingListItem() -> ReadingListItem {
        ReadingListItem(
            book: .init(title: "Memory Police", author: "Yoko Ogawa", isbn: "9782330017781"),
            status: .inProgress
        )
    }
}
