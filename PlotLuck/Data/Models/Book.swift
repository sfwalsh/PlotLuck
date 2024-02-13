//
//  Book.swift
//  PlotLuck
//
//  Created by Stephen Walsh on 12/02/2024.
//

import Foundation
import SwiftData

@Model
final class Book: Equatable {
    let title: String
    let author: String
    let isbn: String
    
    init(title: String, author: String, isbn: String) {
        self.title = title
        self.author = author
        self.isbn = isbn
    }
}
