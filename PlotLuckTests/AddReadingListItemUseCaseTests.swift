//
//  AddReadingListItemUseCaseTests.swift
//  PlotLuckTests
//
//  Created by Stephen Walsh on 12/02/2024.
//

import XCTest
@testable import PlotLuck

final class AddReadingListItemUseCaseTests: XCTestCase {
    
    func testAddReadingListItem_Success() async {
        // Given
        let repository = MockReadingListRepository()
        let useCase = AddReadingListItemUseCase(repository: repository)
        let item = ReadingListItem(book: .init(title: "", author: "", isbn: ""), status: .unread)
        
        // When
        let result = await useCase.execute(for: item)
        
        // Then
        switch result {
        case .success:
            XCTAssertEqual(repository.didAddItemValue, item)
        case .failure:
            XCTFail("Adding item should not fail")
        }
    }
    
    func testAddReadingListItem_Failure() async {
        // Given
        let repository = MockReadingListRepository()
        let useCase = AddReadingListItemUseCase(repository: repository)
        let item = ReadingListItem(book: .init(title: "", author: "", isbn: ""), status: .unread)
        repository.errorValue = MockError(errorDescription: "Could not add Reading List Item")
        
        // When
        let result = await useCase.execute(for: item)
        
        // Then
        switch result {
        case .success:
            XCTFail("Adding item should fail")
        case .failure(let error):
            XCTAssertEqual(error.localizedDescription, "Could not add Reading List Item", "Error should match")
        }
    }
}
