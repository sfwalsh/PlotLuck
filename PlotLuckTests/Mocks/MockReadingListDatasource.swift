//
//  MockReadingListDatasource.swift
//  PlotLuckTests
//
//  Created by Stephen Walsh on 15/02/2024.
//

import Foundation
@testable import PlotLuck

final class MockReadingListDatasource: ReadingListDatasource {
    
    var addItemCallCount = 0
    var addedItem: ReadingListItem?
    
    var updateCallCount = 0
    var updatedModel: ReadingListUpdateModel?
    
    var removeItemCallCount = 0
    var removedItem: ReadingListItem?
    
    var fetchItemsCallCount = 0
    var fetchItemsResult: [ReadingListItem] = []
    
    func addItem(_ item: ReadingListItem) throws {
        addItemCallCount += 1
        addedItem = item
    }
    
    func update(updateModel: ReadingListUpdateModel) throws {
        updateCallCount += 1
        updatedModel = updateModel
    }
    
    func removeItem(_ item: ReadingListItem) throws {
        removeItemCallCount += 1
        removedItem = item
    }
    
    func fetchItems() throws -> [ReadingListItem] {
        fetchItemsCallCount += 1
        return fetchItemsResult
    }
}
