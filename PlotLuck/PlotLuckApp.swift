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
            NavigationStack {
                ReadingListViewFactory()
                    .create(for: .init(modelContext: modelContainer.mainContext))
            }
        }
    }
    
    init() {
        do {
            modelContainer = try ModelContainer(for: ReadingListItem.self, Book.self)
        } catch {
            fatalError("Failed to create ModelContainer.")
        }
        styleNavigationBarAppearance()
    }
    
    private func styleNavigationBarAppearance() {
        
        guard let fontDescriptor = UIFontDescriptor
            .preferredFontDescriptor(withTextStyle: .largeTitle)
            .withDesign(.serif) else { return }

        let appearance = UINavigationBarAppearance()
        let font = UIFont.init(descriptor: fontDescriptor, size: 36)
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font
        ]

        appearance.largeTitleTextAttributes = attributes
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
}
