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
    var title: String
    var author: String
    let isbn: String
    let imageURLString: String?
    
    init(title: String, author: String, isbn: String, imageURLString: String? = nil) {
        self.title = title
        self.author = author
        self.isbn = isbn
        self.imageURLString = imageURLString
    }
}
