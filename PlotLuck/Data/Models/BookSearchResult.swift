//
//  BookSearchResult.swift
//  PlotLuck
//
//  Created by Stephen Walsh on 14/02/2024.
//

import Foundation

struct BookSearchResult: Identifiable, Equatable {
    var id: String {
        isbn
    }
    let imageURLString: String?
    let author, title, isbn: String
}
