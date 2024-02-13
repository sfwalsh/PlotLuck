//
//  MockReadingListRepository.swift
//  PlotLuckTests
//
//  Created by Stephen Walsh on 12/02/2024.
//

import Foundation

@testable import PlotLuck

final class MockReadingListRepository: ReadingListRepository {
    
    var didAddItemValue: ReadingListItem?
    var removedItemValue: ReadingListItem?
    var fetchItemsValue: [ReadingListItem] = []
    var updateModelValue: ReadingListUpdateModel?
    var errorValue: Error?
    
    func addItem(_ item: ReadingListItem) async throws {
        if let errorValue = errorValue {
            throw errorValue
        } else {
            self.didAddItemValue = item
        }
    }
    
    func update(updateModel: ReadingListUpdateModel) async throws {
        if let errorValue = errorValue {
            throw errorValue
        } else {
            self.updateModelValue = updateModel
        }
    }
    
    func removeItem(_ item: ReadingListItem) async throws {
        if let errorValue = errorValue {
            throw errorValue
        } else {
            self.removedItemValue = item
        }
    }
    
    func fetchItems() async throws -> [ReadingListItem] {
        if let errorValue = errorValue {
            throw errorValue
        } else {
            fetchItemsValue
        }
    }
}
