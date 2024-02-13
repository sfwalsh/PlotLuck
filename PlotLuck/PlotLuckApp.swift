//
//  PlotLuckApp.swift
//  PlotLuck
//
//  Created by Stephen Walsh on 12/02/2024.
//

import SwiftUI
import SwiftData

@main
struct PlotLuckApp: App {
    private let modelContainer: ModelContainer
    
    var body: some Scene {
        WindowGroup {
            ReadingListViewFactory()
                .create(for: .init(modelContext: modelContainer.mainContext))
        }
    }
    
    init() {
        do {
            modelContainer = try ModelContainer(for: ReadingListItem.self, Book.self)
        } catch {
            fatalError("Failed to create ModelContainer.")
        }
    }
}
