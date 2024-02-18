//
//  LocalReadingListDataSourceTests.swift
//  PlotLuckTests
//
//  Created by Stephen Walsh on 13/02/2024.
//

import XCTest
import SwiftData
@testable import PlotLuck

@MainActor
final class LocalReadingListDataSourceTests: XCTestCase {
    
    private var modelContainer: ModelContainer?
    private var modelContext: ModelContext?
    private var sut: LocalReadingListDatasource!
    
    override func setUpWithError() throws {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        modelContainer = try ModelContainer(for: ReadingListItem.self, Book.self, configurations: config)
        // force unwrapping here only due to it being the test target
        modelContext = modelContainer?.mainContext
        sut = LocalReadingListDatasource(modelContext: modelContext!)
    }
    
    func testAddItem_Success() throws {
        // When I add an item
        let item = ReadingListItem(
            book: .init(title: "", author: "", isbn: ""),
            status: .unread
        )
        try sut.addItem(item)
        let itemsInContext = try fetchItemsDirectlyFromContext()
        
        // Then
        XCTAssert(itemsInContext.count == 1, "Items should have one item")
        XCTAssertEqual(itemsInContext.first!, item, "The item should match that passed into the sut")
    }
    
    func testFetchItems_EmptyState() throws {
        // Given no items have been added
        // When I call fetch
        let items = try sut.fetchItems()
        // No items are returned
        XCTAssert(items.isEmpty, "items are empty")
    }
    
    func testFetchItems_Success() throws {
        // Given an item is in the context
        let item = ReadingListItem(
            book: .init(title: "", author: "", isbn: ""),
            status: .unread
        )
        try insertItemsDirectlyToContext(items: [item])
        
        // When I call fetch
        let results = try sut.fetchItems()
        
        // then that item is included in the returned results
        XCTAssertEqual(results.first!, item, "The inserted item and the only returned item should be equal")
    }
    
    func testDeleteItem() throws {
        // Given an item is in the context
        let itemToDelete = ReadingListItem(
            book: .init(title: "Item To Delete", author: "A", isbn: "1"),
            status: .unread
        )
        let otherItem = ReadingListItem(
            book: .init(title: "Other Item", author: "A", isbn: "1"),
            status: .unread
        )
        
        try insertItemsDirectlyToContext(items: [
            itemToDelete,
            otherItem
        ])
        
        // When I call remove
        try sut.removeItem(itemToDelete)
        
        // then only that item is removed from the model context
        let itemsInContext = try fetchItemsDirectlyFromContext()
        XCTAssertFalse(itemsInContext.contains(itemToDelete), "the item should be deleted from the context")
        XCTAssertTrue(itemsInContext.contains(otherItem), "any other object should be unaffected")
    }
    
    func testUpdateItem_ReadingStatus() throws {
        // Given an item is in the context
        let itemToUpdate = ReadingListItem(
            book: .init(title: "Item To Update", author: "B", isbn: "2"),
            status: .unread
        )
        try insertItemsDirectlyToContext(items: [
            itemToUpdate
        ])
        
        // When I call dispatch an update operation to its reading status
        let updateModel = ReadingListUpdateModel(
            itemToUpdate: itemToUpdate,
            updateType: .readingStatus(.inProgress)
        )
        try sut.update(updateModel: updateModel)
        
        // then the readingStatus is updated
        let itemsInContext = try fetchItemsDirectlyFromContext()
        XCTAssertEqual(itemsInContext.first!.status, .inProgress, "the item should have update its readingStatus from the context")
    }
    
    func testUpdateItem_BookTitle() throws {
        // Given an item is in the context
        let itemToUpdate = ReadingListItem(
            book: .init(title: "Children of Time", author: "Adrian Tchaikovsky", isbn: "2"),
            status: .unread
        )
        try insertItemsDirectlyToContext(items: [
            itemToUpdate
        ])
        
        // When I call dispatch an update operation to its reading status
        let updateModel = ReadingListUpdateModel(
            itemToUpdate: itemToUpdate,
            updateType: .bookTitle(title: "Children of Ruin")
        )
        try sut.update(updateModel: updateModel)
        
        // then the readingStatus is updated
        let itemsInContext = try fetchItemsDirectlyFromContext()
        XCTAssertEqual(itemsInContext.first!.book.title, "Children of Ruin", "the item should have updated its title from the context")
    }
    
    func testUpdateItem_BookAuthor() throws {
        // Given an item is in the context
        let itemToUpdate = ReadingListItem(
            book: .init(title: "The Sailor Who Fell From Grace With The Sea", author: "Ryūnosuke Akutagawa", isbn: "2"),
            status: .unread
        )
        try insertItemsDirectlyToContext(items: [
            itemToUpdate
        ])
        
        // When I call dispatch an update operation to its reading status
        let updateModel = ReadingListUpdateModel(
            itemToUpdate: itemToUpdate,
            updateType: .bookAuthor(author: "Yukio Mishima")
        )
        try sut.update(updateModel: updateModel)
        
        // then the readingStatus is updated
        let itemsInContext = try fetchItemsDirectlyFromContext()
        XCTAssertEqual(itemsInContext.first!.book.author, "Yukio Mishima", "the item should have updated its author from the context")
    }
}


// MARK: Helper functions

extension LocalReadingListDataSourceTests {
    
    private func fetchItemsDirectlyFromContext() throws -> [ReadingListItem] {
        let descriptor = FetchDescriptor<ReadingListItem>()
        return try modelContext!.fetch(descriptor)
    }
    
    private func insertItemsDirectlyToContext(items: [ReadingListItem]) throws {
        for item in items {
            modelContext?.insert(item)
        }
        try modelContext?.save()
    }
}
