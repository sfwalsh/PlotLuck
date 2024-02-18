//
//  ReadingListViewModelTests.swift
//  PlotLuckTests
//
//  Created by Stephen Walsh on 16/02/2024.
//

import Foundation
import XCTest
import SwiftData
@testable import PlotLuck

@MainActor
final class ReadingListViewModelTests: XCTestCase {
    
    private var sut: ReadingListView.ViewModel!
    private var repository: MockReadingListRepository!
    var mockErrorLogger: MockErrorLogger!

    private var modelContainer: ModelContainer!
    private var modelContext: ModelContext!

    override func setUpWithError() throws {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        modelContainer = try ModelContainer(for: ReadingListItem.self, Book.self, configurations: config)
        // force unwrapping here only due to it being the test target
        modelContext = modelContainer!.mainContext

        mockErrorLogger = MockErrorLogger()
        repository = MockReadingListRepository()
        
        sut = ReadingListView.ViewModel(
            addReadingListItem: .init(repository: repository),
            updateReadingListItemUseCase: .init(repository: repository),
            fetchReadingListItems: .init(repository: repository),
            removeReadingListItemUseCase: .init(repository: repository),
            errorLogger: mockErrorLogger
        )
    }
    
    func testRefreshData_Success() async {
        // Given
        let mockItems = [
            createDummyReadingListItem()
        ]
        repository.fetchItemsValue = mockItems
        
        // When
        sut.refreshData()
        
        // Then
        // testing async code
        let expectation = XCTestExpectation(description: "fetch performed successfully")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertEqual(self.sut.items, mockItems, "ViewModel should update items after successful fetch")
            expectation.fulfill()
        }
        
        await fulfillment(of: [expectation])
    }
    
    func testRefreshData_Failure() async {
        // Given
        let expectedError = MockError(errorDescription: "couldn't fetch local readinglistitems")
        repository.errorValue = expectedError
        
        // When
        sut.refreshData()
        
        // Then
        // testing async code
        let expectation = XCTestExpectation(description: "fetch fails")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertTrue(self.mockErrorLogger.logCalled, "Error logger should be called on fetch failure")
            expectation.fulfill()
        }
        
        await fulfillment(of: [expectation])
    }
    
    func testRemoveReadingListItem() async {
        // Given
        let mockItemToRemove = createDummyReadingListItem()
        
        // When
        sut.removeReadingListItem(mockItemToRemove)
        
        // Then
        // testing async code
        let expectation = XCTestExpectation(description: "repository is notified with item to remove")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertEqual(self.repository.removedItemValue, mockItemToRemove, "Remove reading list item use case should be called")
            expectation.fulfill()
        }
        
        await fulfillment(of: [expectation])
    }
    
    func testToggleReadingListItemStatus() async {
        // Given
        let mockItemToUpdate = createDummyReadingListItem()
        let mockStatus: ReadingStatus = .finished
        
        // When
        sut.toggleReadingListItemStatus(mockItemToUpdate, to: mockStatus)
        
        // Then
        // testing async code
        let expectation = XCTestExpectation(description: "repository is notified with item to update")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let expectedUpdateModel = ReadingListUpdateModel(
                itemToUpdate: mockItemToUpdate,
                updateType: .readingStatus(mockStatus)
            )
            XCTAssertEqual(self.repository.updateModelValue, expectedUpdateModel, "repository layer should be called with the item and parameter to update")
            expectation.fulfill()
        }
        
        await fulfillment(of: [expectation])
    }
}

// MARK: Dummy helpers

extension ReadingListViewModelTests {
    
    private func createDummyReadingListItem() -> ReadingListItem {
        ReadingListItem(
            book: .init(title: "Memory Police", author: "Yoko Ogawa", isbn: "9782330017781", imageURLString: nil),
            status: .inProgress
        )
    }
}
