//
//  ReadingListView.swift
//  PlotLuck
//
//  Created by Stephen Walsh on 13/02/2024.
//

import SwiftUI
import SwiftData

struct ReadingListView: View {
    
    @State private var viewModel: ViewModel
    
    init(viewModel: ViewModel) {
        _viewModel = State(initialValue: viewModel)
    }
    
    var body: some View {
        NavigationStack {
            List(viewModel.items) { item in
                VStack(alignment: .leading) {
                    Text("Test")
                        .font(.headline)
                }
            }
            .navigationTitle("PlotLuck")
            .toolbar {
                Button("Add Sample", action: viewModel.addSampleData)
            }
        }.onAppear {
            viewModel.refreshData()
        }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let modelContainer = try ModelContainer(for: ReadingListItem.self, Book.self, configurations: config)
        
        let factory = ReadingListViewFactory()
        return factory.create(for: .init(modelContext: modelContainer.mainContext))
    } catch {
        fatalError("failed to create in memory model container")
    }
}
