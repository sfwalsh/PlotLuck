//
//  BookSearchViewModelTests.swift
//  PlotLuckTests
//
//  Created by Stephen Walsh on 16/02/2024.
//

import Foundation
import XCTest
import SwiftData
@testable import PlotLuck

@MainActor
final class BookSearchViewModelTests: XCTestCase {

    private var sut: BookSearchView.ViewModel!
    private var bookSearchRepository: MockBookSearchRepository!
    private var readingListRepository: MockReadingListRepository!
    private var mockErrorLogger: MockErrorLogger!
    private var modelContainer: ModelContainer!
    private var modelContext: ModelContext!

    override func setUpWithError() throws {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        modelContainer = try ModelContainer(for: ReadingListItem.self, Book.self, configurations: config)
        // force unwrapping here only due to it being the test target
        modelContext = modelContainer!.mainContext
        
        bookSearchRepository = MockBookSearchRepository()
        readingListRepository = MockReadingListRepository()
        let mockFetchBooksUseCase = FetchBooksUseCase(repository: bookSearchRepository)
        let mockAddReadingListItemUseCase = AddReadingListItemUseCase(repository: readingListRepository)
        mockErrorLogger = MockErrorLogger()
        sut = BookSearchView.ViewModel(
            fetchBooksUseCase: mockFetchBooksUseCase,
            addReadingListItemUseCase: mockAddReadingListItemUseCase,
            errorLogger: mockErrorLogger
        )
    }

    func testPerformSearch_Success() async {
        // Given
        let searchText = "Test"
        let mockResults = [
            createDummyBookSearchResult()
        ]
        bookSearchRepository.fetchResult = mockResults
        
        // When
        sut.searchText = searchText
        sut.performSearch()
        
        // Then
        XCTAssertTrue(sut.activityIndicatorActive, "Activity indicator should be active during search")
        
        // testing async code
        let expectation = XCTestExpectation(description: "Search performed successfully")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertEqual(searchText, self.bookSearchRepository.fetchSearchText, "ViewModel should pass search text to repository layer via use case")
            XCTAssertEqual(self.sut.bookSearchResults, mockResults, "Search results should match the mock results")
            XCTAssertFalse(self.sut.activityIndicatorActive, "Activity indicator should be inactive after search")
            expectation.fulfill()
        }
        
        await fulfillment(of: [expectation])
    }
    
    func testPerformSearch_Failure() async {
        
        // Given
        let searchText = "Test"
        bookSearchRepository.errorValue = MockError(errorDescription: "Could not fetch books!")
        
        // When
        sut.searchText = searchText
        sut.performSearch()
        
        // Then
        XCTAssertTrue(sut.activityIndicatorActive, "Activity indicator should be active during search")
        
        // testing async code
        let expectation = XCTestExpectation(description: "Search performed unsuccessfully")
        XCTAssertTrue(self.sut.activityIndicatorActive, "Activity indicator should be active during search")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertEqual(searchText, self.bookSearchRepository.fetchSearchText, "ViewModel should pass search text to repository layer via use case")
            XCTAssertFalse(self.sut.activityIndicatorActive, "Activity indicator should be inactive after search")
            XCTAssertTrue(self.mockErrorLogger.logCalled, "Error should be logged")
            expectation.fulfill()
        }
        await fulfillment(of: [expectation])
    }

    func testAddBookSearchResultToReadingList_Success() async {
        // Given
        let mockSearchResult = createDummyBookSearchResult()
        let mockReadingStatus: ReadingStatus = .unread
        
        // When
        sut.addBookSearchResultToReadingList(mockSearchResult, readingStatus: mockReadingStatus)
        
        // Then
        // testing async code
        let expectation = XCTestExpectation(description: "Added readinglistitem successfully")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertTrue(self.sut.shouldDismissView, "View should dismiss after successfully adding to reading list")
            XCTAssertNotNil(
                self.readingListRepository.didAddItemValue,
                "there should be a readinglistitem added to the repository"
            )
            expectation.fulfill()
        }
        await fulfillment(of: [expectation])
    }
    
    func testAddBookSearchResultToReadingList_Failure() async {
        // Given
        let mockSearchResult = createDummyBookSearchResult()
        let mockReadingStatus: ReadingStatus = .unread
        let mockError = MockError(errorDescription: "Failed to Add to reading list")
        readingListRepository.errorValue = mockError
        
        // When
        sut.addBookSearchResultToReadingList(mockSearchResult, readingStatus: mockReadingStatus)
        
        // Then
        // testing async code
        let expectation = XCTestExpectation(description: "Added readinglistitem failed")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertFalse(self.sut.shouldDismissView, "View should not dismiss if adding to reading list fails")
            XCTAssertTrue(self.mockErrorLogger.logCalled, "Error should be logged")
            expectation.fulfill()
        }
        await fulfillment(of: [expectation])
    }
}

// MARK: Dummy creation helpers

extension BookSearchViewModelTests {
    
    private func createDummyBookSearchResult() -> BookSearchResult {
        BookSearchResult(
            imageURLString: "https://g.co",
            author: "Herman Melville",
            title: "Moby Dick",
            isbn: "9")
    }
}
