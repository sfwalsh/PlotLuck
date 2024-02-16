//
//  BookSearchView+ViewModel.swift
//  PlotLuck
//
//  Created by Stephen Walsh on 14/02/2024.
//

import Foundation
import Combine

extension BookSearchView {
    
    @Observable
    final class ViewModel {
        
        // Observed properties
        var searchText: String
        private(set) var bookSearchResults: [BookSearchResult]
        var viewDismissalPublisher = PassthroughSubject<Bool, Never>()
        var activityIndicatorActive: Bool
        
        @ObservationIgnored
        private var shouldDismissView = false {
            didSet {
                viewDismissalPublisher.send(shouldDismissView)
            }
        }
        
        // use cases
        
        @ObservationIgnored
        private let fetchBooksUseCase: FetchBooksUseCase
        
        @ObservationIgnored
        private let addReadingListItemUseCase: AddReadingListItemUseCase
        
        @ObservationIgnored
        private let errorLogger: ErrorLogger
        
        init(
            searchText: String = "",
            bookSearchResults: [BookSearchResult] = [],
            fetchBooksUseCase: FetchBooksUseCase,
            addReadingListItemUseCase: AddReadingListItemUseCase,
            errorLogger: ErrorLogger
        ) {
            self.searchText = searchText
            self.bookSearchResults = bookSearchResults
            self.fetchBooksUseCase = fetchBooksUseCase
            self.addReadingListItemUseCase = addReadingListItemUseCase
            self.errorLogger = errorLogger
            self.activityIndicatorActive = false
        }
        
        func performSearch() {
            guard !searchText.isEmpty else { return }
            activityIndicatorActive = true
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
            Task {
                let result = await addReadingListItemUseCase.execute(
                    for: .init(
                        book: .init(
                            title: searchResult.title,
                            author: searchResult.author,
                            isbn: searchResult.isbn,
                            imageURLString: searchResult.imageURLString),
                        status: readingStatus
                    )
                )
                await MainActor.run {
                    handleAddReadingListItemResult(result: result)
                }
            }
        }
        
        private func harvestSearchResults(result: Result<[BookSearchResult], Error>) {
            activityIndicatorActive = false
            switch result {
            case .success(let results):
                bookSearchResults = results
            case .failure(let failure):
                errorLogger.log(for: failure)
                // TODO: present error to user
            }
        }
        
        private func handleAddReadingListItemResult(result: Result<Void, Error>) {
            switch result {
            case .success:
                shouldDismissView = true
            case .failure(let failure):
                errorLogger.log(for: failure)
                // TODO: present error to user
            }
        }
    }
}
