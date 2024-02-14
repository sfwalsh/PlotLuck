//
//  BookSearchResult.swift
//  PlotLuck
//
//  Created by Stephen Walsh on 14/02/2024.
//

import Foundation

struct BookSearchResult: Identifiable {
    var id: String {
        isbn
    }
    let author, title, isbn: String
}
