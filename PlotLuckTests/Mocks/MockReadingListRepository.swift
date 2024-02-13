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
    var errorValue: Error?
    
    func addItem(item: ReadingListItem) async throws {
        if let errorValue = errorValue {
            throw errorValue
        } else {
            self.didAddItemValue = item
        }
    }
    
    func fetchItems() async throws -> [ReadingListItem] {
        []
    }
}
