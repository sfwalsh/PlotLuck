//
//  BookSearchRepository.swift
//  PlotLuck
//
//  Created by Stephen Walsh on 14/02/2024.
//

import Foundation

protocol BookSearchRepository {
    typealias Default = BookSearchRepository
    func fetch(forSearchText searchText: String) async throws -> [BookSearchResult]
}

struct GoogleBookSearchRepository: BookSearchRepository {
    func fetch(forSearchText searchText: String) async throws -> [BookSearchResult] {
        try await Task.sleep(nanoseconds: 150_000_000)
        return [
            BookSearchResult(author: "Haruki Murakami", title: "Killing Commendatore", isbn: "9781784877996"),
            BookSearchResult(author: "Michelle Zauner", title: "Crying in H Mart", isbn: "123489090123"),
            BookSearchResult(author: "Haruki Murakami", title: "Norweigan Wood", isbn: "978175234877996"),
            BookSearchResult(author: "Dan K. Simmons", title: "Hyperion", isbn: "9781784877296"),
        ]
    }
}
