//
//  ReadingListItem.swift
//  PlotLuck
//
//  Created by Stephen Walsh on 12/02/2024.
//

import Foundation

struct ReadingListItem: Equatable {
    static func == (lhs: ReadingListItem, rhs: ReadingListItem) -> Bool {
        lhs.book == rhs.book && lhs.status == rhs.status
    }
    
    let book: Book
    let status: ReadingStatus
}
