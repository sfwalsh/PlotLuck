//
//  ReadingListItem.swift
//  PlotLuck
//
//  Created by Stephen Walsh on 12/02/2024.
//

import Foundation
import SwiftData

@Model
final class ReadingListItem: Equatable {
    
    let book: Book
    let status: ReadingStatus
    
    init(book: Book, status: ReadingStatus) {
        self.book = book
        self.status = status
    }
}
