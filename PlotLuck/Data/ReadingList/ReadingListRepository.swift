//
//  ReadingListRepository.swift
//  PlotLuck
//
//  Created by Stephen Walsh on 12/02/2024.
//

import Foundation

protocol ReadingListRepository {
    typealias Default = DefaultReadingListRepository
    func addItem(item: ReadingListItem) async throws
}

struct DefaultReadingListRepository: ReadingListRepository {
    
    private let datasource: ReadingListDatasource
    
    init(datasource: ReadingListDatasource) {
        self.datasource = datasource
    }
    
    func addItem(item: ReadingListItem) async throws {
        try await datasource.addItem(item: item)
    }
}
