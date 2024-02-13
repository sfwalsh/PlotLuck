//
//  ReadingListView+ViewModel.swift
//  PlotLuck
//
//  Created by Stephen Walsh on 13/02/2024.
//

import Foundation
import SwiftData

// MARK: ViewModel extension
// declared inside an extension of the view to give it a local name of ViewModel, while externally accessable view dot notation
extension ReadingListView {
    
    @Observable
    final class ViewModel {
        
        // Use cases
        
        // Disables observation tracking of use cases
        @ObservationIgnored
        private let addReadingListItem: AddReadingListItemUseCase

        @ObservationIgnored
        private let fetchReadingListItems: FetchReadingListItemsUseCase
        
        private let errorLogger: ErrorLogger
        
        private(set) var items: [ReadingListItem]
        
        init(
            addReadingListItem: AddReadingListItemUseCase,
            fetchReadingListItems: FetchReadingListItemsUseCase,
            errorLogger: ErrorLogger
        ) {
            self.addReadingListItem = addReadingListItem
            self.fetchReadingListItems = fetchReadingListItems
            self.items = []
            self.errorLogger = errorLogger
        }
        
        func addSampleData() {
            Task {
                let book = Book(title: "", author: "", isbn: "")
                let item = ReadingListItem(book: book, status: .unread)
                let result = await addReadingListItem.execute(for: item)
                
                await MainActor.run {
                    switch result {
                    case .success:
                        refreshData()
                    case .failure(let error):
                        catchError(e: error)
                    }
                }
            }
        }
        
        func refreshData() {
            Task {
                let result = await fetchReadingListItems.execute()
                await MainActor.run {
                    switch result {
                    case .success(let items):
                        self.items = items
                    case .failure(let error):
                        catchError(e: error)
                    }
                }
            }
        }
        
        private func catchError(e: Error) {
            errorLogger.log(for: e)
            // TODO: present error to user
        }
    }
}
