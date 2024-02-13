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
        
        @ObservationIgnored
        private let addReadingListItem: AddReadingListItemUseCase
        
        private let errorLogger: ErrorLogger
        
        private(set) var items: [ReadingListItem]
        
        init(
            addReadingListItem: AddReadingListItemUseCase,
            errorLogger: ErrorLogger
        ) {
            self.addReadingListItem = addReadingListItem
            self.items = []
            self.errorLogger = errorLogger
        }
        
        func addSampleData() {
            Task {
                let book = Book(title: "", author: "", isbn: "")
                let item = ReadingListItem(book: book, status: .unread)
                let result = await addReadingListItem.execute(for: item)
                
                switch result {
                case .success:
                    break
                case .failure(let error):
                    errorLogger.log(for: error)
                    await MainActor.run {
                        // TODO: present error to user
                    }
                    break
                }
            }
        }
    }
}
