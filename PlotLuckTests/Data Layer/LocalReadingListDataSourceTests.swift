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
        try sut.addItem(item: item)
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
        try insertItemDirectlyToContext(item: item)
        
        // When I call fetch
        let results = try sut.fetchItems()
        
        // then that item is included in the returned results
        XCTAssertEqual(results.first!, item, "The inserted item and the only returned item should be equal")
    }
}


// MARK: Helper functions

extension LocalReadingListDataSourceTests {
    
    private func fetchItemsDirectlyFromContext() throws -> [ReadingListItem] {
        let descriptor = FetchDescriptor<ReadingListItem>()
        return try modelContext!.fetch(descriptor)
    }
    
    private func insertItemDirectlyToContext(item: ReadingListItem) throws {
        modelContext?.insert(item)
        try modelContext?.save()
    }
}
