//
//  ReadingListView.swift
//  PlotLuck
//
//  Created by Stephen Walsh on 13/02/2024.
//

import SwiftUI
import SwiftData

struct ReadingListView: View {
    
    @Environment(\.modelContext) var modelContext
    
    @State private var viewModel: ViewModel
    @State private var showingBookSearchView = false
    
    init(viewModel: ViewModel) {
        _viewModel = State(initialValue: viewModel)
    }
    
    var body: some View {
        List {
            ForEach(viewModel.items) { item in
                buildReadingListItemCell(for: item)
                .swipeActions(edge: .trailing) {
                    createDeleteItemButton(for: item)
                    createItemStatusToggleButton(for: item)
                }
            }
        }
        .listStyle(.inset)
        .navigationTitle("PlotLuck")
        .toolbar {
            Button {
                showingBookSearchView.toggle()
            } label: {
                Image(systemName: "plus")
            }
            .sheet(isPresented: $showingBookSearchView) {
                BookSearchViewFactory().create(for: .init(modelContext: modelContext))
            }
        }
        .onChange(of: showingBookSearchView, { oldValue, newValue in
            viewModel.refreshData()
        })
        .onAppear {
            viewModel.refreshData()
        }.errorAlert(error: $viewModel.presentedError)
    }
    
    // Customisations to the encapsulating layout of the ListItemCell happen here,
    // allowing the reuse of the shared functionality in BookSearchView
    @ViewBuilder
    private func buildReadingListItemCell(for item: ReadingListItem) -> some View {
        VStack(alignment: .leading, spacing: 20) {
            ListItemCell(
                titleText: item.book.title,
                subtitleText: item.book.author, 
                imageURLString: item.book.imageURLString,
                footnoteText: item.status.localizedDescription
            )
            Divider()
                .frame(height: 0.5)
                .overlay(Color.primary)
                .opacity(0.4)
                .padding(.horizontal, 12)
        }
        .padding(.top, 20)
        .listRowSeparator(.hidden)
    }
    
    @ViewBuilder
    private func createDeleteItemButton(for item: ReadingListItem) -> some View {
        Button(role: .destructive) {
            viewModel.removeReadingListItem(item)
        } label: {
            Label("SwipeAction.Delete.Title", systemImage: "trash")
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
                Label("SwipeAction.Finished.Title", systemImage: "book.closed")
            }
        case .unread, .finished:
            Button {
                viewModel.toggleReadingListItemStatus(
                    item, to: .inProgress
                )
            } label: {
                Label("SwipeAction.InProgress.Title", systemImage: "book")
            }
        }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let modelContainer = try ModelContainer(for: ReadingListItem.self, Book.self, configurations: config)
        
        let factory = ReadingListViewFactory()
        return NavigationStack {
            factory.create(for: .init(modelContext: modelContainer.mainContext))
        }
    } catch {
        fatalError("failed to create in memory model container")
    }
}

