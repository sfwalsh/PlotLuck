//
//  ReadingListRepository.swift
//  PlotLuck
//
//  Created by Stephen Walsh on 12/02/2024.
//

import Foundation

protocol ReadingListRepository {
    typealias Default = DefaultReadingListRepository
    func addItem(_ item: ReadingListItem) async throws
    func removeItem(_ item: ReadingListItem) async throws
    func fetchItems() async throws -> [ReadingListItem]
}

struct DefaultReadingListRepository: ReadingListRepository {
    
    private let datasource: ReadingListDatasource
    
    init(datasource: ReadingListDatasource) {
        self.datasource = datasource
    }
    
    func addItem(_ item: ReadingListItem) async throws {
        try datasource.addItem(item)
    }
    
    func removeItem(_ item: ReadingListItem) async throws {
        try datasource.removeItem(item)
    }
    
    func fetchItems() async throws -> [ReadingListItem] {
        try datasource.fetchItems()
    }
}
