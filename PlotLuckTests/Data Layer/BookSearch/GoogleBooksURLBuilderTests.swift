//
//  GoogleBooksURLBuilderTests.swift
//  PlotLuckTests
//
//  Created by Stephen Walsh on 15/02/2024.
//

import Foundation
import XCTest
@testable import PlotLuck

final class GoogleBooksURLBuilderTests: XCTestCase {
    
    let baseURLString = "https://www.googleapis.com/books/v1/"
    let apiKey = "ABCD"
    
    func testBuildBookSearchURL() {
        // Given
        let builder = GoogleBooksURLBuilder(baseURLString: baseURLString, apiKey: apiKey)
        let searchTerm = "Harry Potter and The Quinlans\\"
        
        // When
        do {
            let url = try builder.buildBookSearchURL(for: searchTerm)
            
            // Then
            XCTAssertEqual(url.scheme, "https")
            XCTAssertEqual(url.host, "www.googleapis.com")
            XCTAssertEqual(url.path, "/books/v1/volumes")
            
            let queryItems = URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems
            XCTAssertTrue(queryItems?.contains(URLQueryItem(name: "q", value: searchTerm)) ?? false)
            XCTAssertTrue(queryItems?.contains(URLQueryItem(name: "key", value: apiKey)) ?? false)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
}
