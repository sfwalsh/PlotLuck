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
    
    let datasource: BookSearchDatasource
    
    func fetch(forSearchText searchText: String) async throws -> [BookSearchResult] {
        return try await datasource.fetch(for: searchText)
    }
}
