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
        
        enum CodingKeys: String, CodingKey {
            case title, authors, industryIdentifiers, imageLinks
        }
        
        let title: String?
        let authors: [String]?
        let industryIdentifiers: [IndustryIdentifiers]?
        let imageLinks: ImageLinks?
        
        init(title: String?, authors: [String]?, industryIdentifiers: [IndustryIdentifiers]?, imageLinks: ImageLinks?) {
            self.title = title
            self.authors = authors
            self.industryIdentifiers = industryIdentifiers
            self.imageLinks = imageLinks
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            title = try container.decodeIfPresent(String.self, forKey: .title)
            authors = try container.decodeIfPresent([String].self, forKey: .authors)
            industryIdentifiers = try container.decodeIfPresent([IndustryIdentifiers].self, forKey: .industryIdentifiers)
            imageLinks = try container.decodeIfPresent(ImageLinks.self, forKey: .imageLinks)
        }
    }
    
    struct ImageLinks: Decodable {
        let smallThumbnail: String?
        let thumbnail: String?
    }
    
    struct IndustryIdentifiers: Decodable {
        let type, identifier: String
    }
    
    struct Item: Decodable {
        let id: String
        let volumeInfo: VolumeInfo
    }
    
    let items: [Item]
}
