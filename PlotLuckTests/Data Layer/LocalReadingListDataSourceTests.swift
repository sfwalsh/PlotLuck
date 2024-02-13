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
    private var sut: LocalReadingListDatasource?
    
    override func setUpWithError() throws {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        modelContainer = try ModelContainer(for: ReadingListItem.self, Book.self, configurations: config)
        // force unwrapping here only due to it being the test target
        modelContext = modelContainer?.mainContext
        sut = LocalReadingListDatasource(modelContext: modelContext!)
    }

    func testAddItem_Success() async throws {
        // Given
        let itemsBefore = try fetchItemsFromContext()
        XCTAssert(itemsBefore.isEmpty, "Items should be empty")
        
        // When I insert an item
        let item = ReadingListItem(
            book: .init(title: "", author: "", isbn: ""),
            status: .unread
        )
        try await sut?.addItem(item: item)
        
        let itemsAfter = try fetchItemsFromContext()
        
        // Then
        XCTAssert(itemsAfter.count == 1, "Items should have one item")
        XCTAssertEqual(itemsAfter.first!, item, "The item should match that passed into the sut")
    }
    
    // convienence function for retrieving current items in the SwiftData layer
    private func fetchItemsFromContext() throws -> [ReadingListItem] {
        let descriptor = FetchDescriptor<ReadingListItem>()
        return try modelContext!.fetch(descriptor)
    }
}
