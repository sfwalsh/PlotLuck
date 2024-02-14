//
//  BookSearchView.swift
//  PlotLuck
//
//  Created by Stephen Walsh on 14/02/2024.
//

import SwiftUI

struct BookSearchView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State private var viewModel: ViewModel
    
    init(viewModel: ViewModel) {
        _viewModel = State(initialValue: viewModel)
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.bookSearchResults) { result in
                    buildCell(forSearchResult: result)
                }
            }
            .listStyle(.plain)
            .searchable(
                text: $viewModel.searchText,
                placement: .navigationBarDrawer(displayMode:.always)
            )
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
                footnoteText: nil
            )
            Spacer()
            Button {
                // TODO: Add feature to assign reading status from search result page
                viewModel.addBookSearchResultToReadingList(
                    result,
                    readingStatus: .unread
                )
                dismiss()
            } label: {
                Text("Add \(Image(systemName: "plus"))")
            }.buttonStyle(.borderedProminent)
        }
    }
}

#Preview {
    BookSearchViewFactory().create(for: .init())
}
