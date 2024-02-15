//
//  GoogleBooksDataSourceTests.swift
//  PlotLuckTests
//
//  Created by Stephen Walsh on 15/02/2024.
//

import XCTest
@testable import PlotLuck

final class GoogleBooksDataSourceTests: XCTestCase {
    
    private var network: MockNetworkInterface!
    private var urlBuilder: MockURLBuilder!
    private var sut: GoogleBooksDataSource!
    
    override func setUp() async throws {
        network = MockNetworkInterface()
        urlBuilder = MockURLBuilder()
        sut = GoogleBooksDataSource(network: network, urlBuilder: urlBuilder)
    }
    
    func testFetchWithValidData() async throws {
        // Given
        let validResponse = GoogleBookSearchResponse(items: [
            createGoogleBookSearchResponseItem()
        ])
        network.fetchDataReturnValue = validResponse
        
        // When
        let results = try await sut.fetch(for: "Potterworld")
        
        // Then
        XCTAssertEqual(results.count, 1)
        XCTAssertEqual(results[0].title, validResponse.items.first?.volumeInfo.title)
        XCTAssertEqual(results[0].author, validResponse.items.first?.volumeInfo.authors?.first)
        XCTAssertEqual(results[0].isbn, validResponse.items.first?.volumeInfo.industryIdentifiers?.first?.identifier)
    }
    
    func testFetchWithNoAuthor() async throws {
        // Given
        let responseWithInvalidItem = GoogleBookSearchResponse(items: [
            createGoogleBookSearchResponseItem(volumeInfoAuthors: []) // empty authors array
        ])
        network.fetchDataReturnValue = responseWithInvalidItem
        
        // When
        let results = try await sut.fetch(for: "Something obscure")
        
        // Then
        XCTAssertEqual(results.count, 0, "if there is no author provided, the result should be omitted")
    }
    
    func testFetchWithOneAuthor() async throws {
        // Given
        let response = GoogleBookSearchResponse(items: [
            createGoogleBookSearchResponseItem(volumeInfoAuthors: ["Pavarotti"])
        ])
        network.fetchDataReturnValue = response
        
        // When
        let results = try await sut.fetch(for: "O Solo Mio")
        
        // Then
        XCTAssertEqual(results.count, 1)
    }
    
    func testFetchWithMultipleAuthors() async throws {
        // Given
        let response = GoogleBookSearchResponse(items: [
            createGoogleBookSearchResponseItem(volumeInfoAuthors: ["Pavarotti", "Plácido Domingo", "José Carreras"])
        ])
        network.fetchDataReturnValue = response
        
        // When
        let results = try await sut.fetch(for: "The Three Tenors: Our Tenure")
        
        // Then
        let expectedAuthors = response.items.first?.volumeInfo.authors?.joined(separator: ", ")
        XCTAssertEqual(results.count, 1)
        XCTAssertEqual(results[0].author, expectedAuthors, "authors should be formatted as a comma separated string")
    }
    
    func testFetchWithNoTitle() async throws {
        // Given
        let response = GoogleBookSearchResponse(items: [
            createGoogleBookSearchResponseItem(volumeInfoTitle: nil)
        ])
        network.fetchDataReturnValue = response
        
        // When
        let results = try await sut.fetch(for: "Ghosts")
        
        // Then
        XCTAssertEqual(results.count, 0, "if there is no title provided, the result should be omitted")
    }
    
    func testFetchWithNoISBN() async throws {
        // Given
        let response = GoogleBookSearchResponse(items: [
            createGoogleBookSearchResponseItem(volumeInfoIndustryIdentifiers: nil)
        ])
        network.fetchDataReturnValue = response
        
        // When
        let results = try await sut.fetch(for: "Rogue Publishers")
        
        // Then
        XCTAssertEqual(results.count, 0, "if there is no isbn provided, the result should be omitted")
    }
    
    func testFetchWithURLBuilderError() async {
        // Given
        let response = GoogleBookSearchResponse(items: [
            createGoogleBookSearchResponseItem()
        ])
        network.fetchDataReturnValue = response
        urlBuilder.errorValue = MockError(errorDescription: "invalid search term")
        
        // When
        do {
            let _ = try await sut.fetch(for: "Breaking Search Term")
            XCTFail("error should have been thrown")
        } catch {
            // Then
            XCTAssertEqual(error.localizedDescription, "invalid search term", "error should be thrown")
        }
    }
    
    func testFetchWithNetworkError() async throws {
        // Given
        let response = GoogleBookSearchResponse(items: [
            createGoogleBookSearchResponseItem()
        ])
        network.errorValue = MockError(errorDescription: "invalid results")
        
        // When
        do {
            let _ = try await sut.fetch(for: "Something goes wrong")
            XCTFail("error should have been thrown")
        } catch {
            // Then
            XCTAssertEqual(error.localizedDescription, "invalid results", "error should be thrown")
        }
    }
}

// MARK: dummy data creation helper functions

extension GoogleBooksDataSourceTests {
    
    private func createGoogleBookSearchResponseItem(
        volumeInfoTitle: String? = "Harry Potter",
        volumeInfoAuthors: [String]? = ["JK Quinlan"],
        volumeInfoIndustryIdentifiers: [GoogleBookSearchResponse.IndustryIdentifiers]? = [.init(type: "ISBN_13", identifier: "1234567890")]
    ) -> GoogleBookSearchResponse.Item {
        .init(
            id: "123",
            volumeInfo: .init(
                title: volumeInfoTitle,
                authors: volumeInfoAuthors,
                industryIdentifiers: volumeInfoIndustryIdentifiers
            )
        )
    }
}
