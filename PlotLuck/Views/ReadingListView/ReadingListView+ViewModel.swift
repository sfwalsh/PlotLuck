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
        
        @ObservationIgnored
        private let removeReadingListItemUseCase: RemoveReadingListItemUseCase
        
        private let errorLogger: ErrorLogger
        
        private(set) var items: [ReadingListItem]
        
        init(
            addReadingListItem: AddReadingListItemUseCase,
            fetchReadingListItems: FetchReadingListItemsUseCase,
            removeReadingListItemUseCase: RemoveReadingListItemUseCase,
            errorLogger: ErrorLogger
        ) {
            self.addReadingListItem = addReadingListItem
            self.fetchReadingListItems = fetchReadingListItems
            self.removeReadingListItemUseCase = removeReadingListItemUseCase
            
            self.items = []
            self.errorLogger = errorLogger
        }
        
        func addSampleData() {
            Task {
                let dummyBooks = [
                    Book(title: "Crying in H Mart", author: "Michelle Zauner", isbn: "1234567890123"),
                    Book(title: "Norweigan Wood", author: "Haruki Murakami", isbn: "9781784877996"),
                    Book(title: "Hyperion", author: "Dan K. Simmons", isbn: "9781784877996"),
                ]
                let book = dummyBooks[Int.random(in: 0...dummyBooks.count-1)]
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
        
        func didDeleteReadingListItems(at indexSet: IndexSet) {
            Task {
                for index in indexSet {
                    let item = items[index]
                    let _ = await removeReadingListItemUseCase.execute(for: item)
                }
                refreshData()
            }
        }
        
        private func catchError(e: Error) {
            errorLogger.log(for: e)
            // TODO: present error to user
        }
    }
}
