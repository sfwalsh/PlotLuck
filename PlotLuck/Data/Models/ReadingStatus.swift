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
            "Unread"
        case .inProgress:
            "In Progress"
        case .finished:
            "Finished"
        }
    }
}
