//
//  ReadingListItemUpdateModel.swift
//  PlotLuck
//
//  Created by Stephen Walsh on 13/02/2024.
//

import Foundation
import SwiftData

struct ReadingListUpdateModel {
    
    let itemToUpdate: ReadingListItem
    let updateType: ReadingListItemUpdateType
    
    enum ReadingListItemUpdateType: Equatable {
        case readingStatus(ReadingStatus)
        case bookTitle(title: String)
        case bookAuthor(author: String)
    }
}

// MARK: Equatable conformance
extension ReadingListUpdateModel: Equatable {
    static func == (lhs: ReadingListUpdateModel, rhs: ReadingListUpdateModel) -> Bool {
        return lhs.itemToUpdate == rhs.itemToUpdate && lhs.updateType == rhs.updateType
    }
}
