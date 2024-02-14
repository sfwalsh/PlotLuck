//
//  GoogleBookSearchResponse.swift
//  PlotLuck
//
//  Created by Stephen Walsh on 14/02/2024.
//

import Foundation

// A model that matches the Google Books API Response
struct GoogleBookSearchResponse: Decodable {
    
    // Note the model is incomplete and only stores data needed by the app.
    struct VolumeInfo: Decodable {
        let title: String
        let authors: [String]
        let industryIdentifiers: [IndustryIdentifiers]
    }
    
    struct IndustryIdentifiers: Decodable {
        let type, identifier: String
    }
    
    let id: String
    let volumeInfo: VolumeInfo
}
