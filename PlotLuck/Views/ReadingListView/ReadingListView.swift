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
            List {
                ForEach(viewModel.items) { item in
                    createReadingListItemCell(for: item)
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
    
    @ViewBuilder
    private func createReadingListItemCell(for item: ReadingListItem) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(item.book.title)
                .font(.headline)
            Text(item.book.author)
                .font(.subheadline)
            Text(item.status.rawValue.localizedCapitalized)
                .font(.footnote)
        }
        .padding(.vertical, 16)
        .swipeActions(edge: .trailing) {
            createDeleteItemButton(for: item)
            createItemStatusToggleButton(for: item)
        }
    }
    
    @ViewBuilder
    private func createDeleteItemButton(for item: ReadingListItem) -> some View {
        Button(role: .destructive) {
            viewModel.removeReadingListItem(item)
        } label: {
            Label("Delete", systemImage: "trash")
        }
    }
    
    @ViewBuilder
    private func createItemStatusToggleButton(for item: ReadingListItem) -> some View {
        switch item.status {
        case .inProgress:
            Button {
                viewModel.toggleReadingListItemStatus(
                    item, to: .finished
                )
            } label: {
                Label("Mark Finished", systemImage: "book.closed")
            }
        case .unread, .finished:
            Button {
                viewModel.toggleReadingListItemStatus(
                    item, to: .inProgress
                )
            } label: {
                Label("Mark in Progress", systemImage: "book")
            }
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

