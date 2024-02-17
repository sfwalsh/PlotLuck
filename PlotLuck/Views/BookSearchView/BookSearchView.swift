//
//  BookSearchView.swift
//  PlotLuck
//
//  Created by Stephen Walsh on 14/02/2024.
//

import SwiftUI
import SwiftData

struct BookSearchView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State private var viewModel: ViewModel
    
    init(viewModel: ViewModel) {
        _viewModel = State(initialValue: viewModel)
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                List {
                    ForEach(viewModel.bookSearchResults) { result in
                        buildCell(forSearchResult: result)
                    }
                }.overlay {
                    if viewModel.activityIndicatorActive {
                        ProgressView()
                    } else if viewModel.bookSearchResults.isEmpty {
                            ContentUnavailableView(
                                String(localized: "BookSearch.EmptyState.Title"),
                                systemImage: "book",
                                description: Text(String(localized: "BookSearch.EmptyState.Description"))
                            )
                    }
                }
            }
            .listStyle(.plain)
            .searchable(
                text: $viewModel.searchText,
                placement: .navigationBarDrawer(displayMode:.always)
            )
            .onReceive(viewModel.viewDismissalPublisher) { shouldDismiss in
                if shouldDismiss {
                    dismiss()
                }
            }
            .onSubmit(of: .search) {
                viewModel.performSearch()
            }
            .toolbar {
                Button("Done") {
                    dismiss()
                }
                .fontWeight(.medium)
            }
        }
    }
    
    @ViewBuilder
    private func buildCell(forSearchResult result: BookSearchResult) -> some View {
        HStack {
            ListItemCell(
                titleText: result.title,
                subtitleText: result.author, 
                imageURLString: result.imageURLString,
                footnoteText: nil
            )
            Spacer()
            Button {
                // TODO: Add feature to assign reading status from search result page
                viewModel.addBookSearchResultToReadingList(
                    result,
                    readingStatus: .unread
                )
            } label: {
                Text("Add \(Image(systemName: "plus"))")
            }.buttonStyle(.borderedProminent)
        }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let modelContainer = try ModelContainer(for: ReadingListItem.self, Book.self, configurations: config)
        
        let factory = BookSearchViewFactory()
        return NavigationStack {
            factory
                .create(for: .init(modelContext: modelContainer.mainContext))
        }
    } catch {
        fatalError("failed to create in memory model container")
    }
}
