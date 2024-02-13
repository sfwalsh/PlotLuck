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
    func update(updateModel: ReadingListUpdateModel) throws
    func removeItem(_ item: ReadingListItem) throws
    func fetchItems() throws -> [ReadingListItem]
}

struct LocalReadingListDatasource: ReadingListDatasource {
    private let modelContext: ModelContext
    
    @MainActor
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func addItem(_ item: ReadingListItem) throws {
        modelContext.insert(item)
        try modelContext.save()
    }
    
    func update(updateModel: ReadingListUpdateModel) throws {
        switch updateModel.updateType {
        case .readingStatus(let readingStatus):
            updateModel.itemToUpdate.status = readingStatus
        case .bookTitle(let title):
            break
        case .bookAuthor(let author):
            break
        }
        try modelContext.save()
    }
    
    func removeItem(_ item: ReadingListItem) throws {
        modelContext.delete(item)
        try modelContext.save()
    }
    
    func fetchItems() throws -> [ReadingListItem] {
        try modelContext.fetch(FetchDescriptor<ReadingListItem>(sortBy:  [SortDescriptor(\.book.title)]))
    }
}
