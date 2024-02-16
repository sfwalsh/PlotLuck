//
//  Secrets.swift
//  PlotLuck
//
//  Created by Stephen Walsh on 15/02/2024.
//

import Foundation

struct SecretsInterface {
 
    // Singleton object, since there is only ever going to be one secret collection
    static let shared = SecretsInterface()
    
    private enum CodingKeys: String, CodingKey {
        case secretCollection = "SecretCollection"
        case plist
        case googleBooksAPIKey
    }
        
    let googleBooksAPIKey: String
    
    private init() {
        do {
            guard let path = Bundle.main.path(
                forResource: CodingKeys.secretCollection.rawValue,
                ofType: CodingKeys.plist.rawValue
            ) else {
                fatalError("Add SecretCollection to your project")
            }
            let url = URL(fileURLWithPath: path)
            let data = try Data(contentsOf: url)
            guard let secretsCollection = try PropertyListSerialization.propertyList(from: data, options: .mutableContainers, format: nil) as? [String: String],
            let googleBooksAPIKey = secretsCollection[CodingKeys.googleBooksAPIKey.rawValue]
            else {
                fatalError("Add SecretCollection to your project")
            }
            self.googleBooksAPIKey = googleBooksAPIKey
        } catch {
            fatalError("Add SecretCollection to your project")
        }
    }
}
