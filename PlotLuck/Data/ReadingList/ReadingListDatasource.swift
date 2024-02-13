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
    func addItem(item: ReadingListItem) async throws
}

struct LocalReadingListDatasource: ReadingListDatasource {
    private let modelContext: ModelContext
    
    @MainActor
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func addItem(item: ReadingListItem) async throws {
        modelContext.insert(item)
        try modelContext.save()
    }
}
