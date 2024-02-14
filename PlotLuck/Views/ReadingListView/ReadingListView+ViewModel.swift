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
        private let updateReadingListItemUseCase: UpdateReadingListItemUseCase
        
        @ObservationIgnored
        private let fetchReadingListItems: FetchReadingListItemsUseCase
        
        @ObservationIgnored
        private let removeReadingListItemUseCase: RemoveReadingListItemUseCase
        
        private let errorLogger: ErrorLogger
        
        private(set) var items: [ReadingListItem]
        
        init(
            addReadingListItem: AddReadingListItemUseCase,
            updateReadingListItemUseCase: UpdateReadingListItemUseCase,
            fetchReadingListItems: FetchReadingListItemsUseCase,
            removeReadingListItemUseCase: RemoveReadingListItemUseCase,
            errorLogger: ErrorLogger
        ) {
            self.addReadingListItem = addReadingListItem
            self.updateReadingListItemUseCase = updateReadingListItemUseCase
            self.fetchReadingListItems = fetchReadingListItems
            self.removeReadingListItemUseCase = removeReadingListItemUseCase
            
            self.items = []
            self.errorLogger = errorLogger
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
        
        func removeReadingListItem(_ item: ReadingListItem) {
            Task {
                let _ = await removeReadingListItemUseCase.execute(for: item)
                refreshData()
            }
        }
        
        func toggleReadingListItemStatus(
            _ item: ReadingListItem,
            to status: ReadingStatus
        ) {
            Task {
                let update = ReadingListUpdateModel(
                    itemToUpdate: item,
                    updateType: .readingStatus(status)
                )
                let _ = await updateReadingListItemUseCase.execute(for: update)
                refreshData()
            }
        }
        
        private func catchError(e: Error) {
            errorLogger.log(for: e)
            // TODO: present error to user
        }
    }
}
