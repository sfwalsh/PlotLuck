//
//  ReadingListDatasource.swift
//  PlotLuck
//
//  Created by Stephen Walsh on 12/02/2024.
//

import Foundation
import SwiftData

protocol ReadingListDatasource {
    typealias Default = LocalReadingListDatasource
    func addItem(_ item: ReadingListItem) throws
    func removeItem(_ item: ReadingListItem) throws
    func fetchItems() throws -> [ReadingListItem]
}

struct LocalReadingListDatasource: ReadingListDatasource {
    private let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func addItem(_ item: ReadingListItem) throws {
        modelContext.insert(item)
        try modelContext.save()
    }
    
    func removeItem(_ item: ReadingListItem) throws {
        modelContext.delete(item)
    }
    
    func fetchItems() throws -> [ReadingListItem] {
        try modelContext.fetch(FetchDescriptor<ReadingListItem>())
    }
}
