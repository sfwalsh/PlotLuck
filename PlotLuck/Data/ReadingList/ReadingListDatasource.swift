//
//  ReadingListDatasource.swift
//  PlotLuck
//
//  Created by Stephen Walsh on 12/02/2024.
//

import Foundation

protocol ReadingListDatasource {
    typealias Default = LocalReadingListDatasource
    func addItem(item: ReadingListItem) async throws
}

struct LocalReadingListDatasource: ReadingListDatasource {
    func addItem(item: ReadingListItem) async throws {
        
    }
}
