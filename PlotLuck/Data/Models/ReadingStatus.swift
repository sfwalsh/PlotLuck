//
//  ReadingStatus.swift
//  PlotLuck
//
//  Created by Stephen Walsh on 12/02/2024.
//

import Foundation
import SwiftData

enum ReadingStatus: String, Codable, Equatable {
    case unread, inProgress, finished
    
    var localizedDescription: String {
        switch self {
        case .unread:
            String(localized: "statusUnread")
        case .inProgress:
            String(localized: "statusInProgress")
        case .finished:
            String(localized: "statusFinished")
        }
    }
}
