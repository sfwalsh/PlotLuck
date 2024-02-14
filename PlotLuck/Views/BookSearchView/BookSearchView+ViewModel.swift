//
//  BookSearchView+ViewModel.swift
//  PlotLuck
//
//  Created by Stephen Walsh on 14/02/2024.
//

import Foundation

extension BookSearchView {
    
    @Observable
    final class ViewModel {
        var searchText: String
        private(set) var bookSearchResults: [BookSearchResult]
        
        // use cases
        
        @ObservationIgnored
        private let fetchBooksUseCase: FetchBooksUseCase
        
        private let errorLogger: ErrorLogger
        
        init(
            searchText: String = "",
            bookSearchResults: [BookSearchResult] = [],
            fetchBooksUseCase: FetchBooksUseCase,
            errorLogger: ErrorLogger
        ) {
            self.searchText = searchText
            self.bookSearchResults = bookSearchResults
            self.fetchBooksUseCase = fetchBooksUseCase
            self.errorLogger = errorLogger
        }
        
        func performSearch() {
            guard !searchText.isEmpty else { return }
            Task {
                let result = await fetchBooksUseCase.execute(for: .init(searchText: searchText))
                
                await MainActor.run {
                    harvestSearchResults(result: result)
                }
            }
        }
        
        func addBookSearchResultToReadingList(
            _ searchResult: BookSearchResult,
            readingStatus: ReadingStatus
        ) {
            
        }
        
        private func harvestSearchResults(result: Result<[BookSearchResult], Error>) {
            switch result {
            case .success(let results):
                bookSearchResults = results
            case .failure(let failure):
                errorLogger.log(for: failure)
                // TODO: present error to user
            }
        }
    }
}
