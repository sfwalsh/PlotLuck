//
//  FetchBooksUseCase.swift
//  PlotLuck
//
//  Created by Stephen Walsh on 14/02/2024.
//

import Foundation

struct FetchBooksUseCase: UseCase {
    typealias RequestType = RequestValues
    typealias ResponseType = [BookSearchResult]
    
    private let repository: BookSearchRepository
    
    init(repository: BookSearchRepository) {
        self.repository = repository
    }
    
    func execute(for request: RequestValues) async -> Result<[BookSearchResult], Error> {
        do {
            let results = try await repository.fetch(forSearchText: request.searchText)
            return .success(results)
        } catch {
            return .failure(error)
        }
    }
}

extension FetchBooksUseCase {
    struct RequestValues {
        let searchText: String
    }
}
