//
//  BookSearchFactory.swift
//  PlotLuck
//
//  Created by Stephen Walsh on 14/02/2024.
//

import Foundation
import SwiftData

struct BookSearchViewFactory: ViewFactory {
    typealias RequestValueType = RequestValues
    typealias ViewType = BookSearchView
    
    @MainActor
    func create(for requestValue: RequestValues) -> BookSearchView {
        let urlSession = URLSession.shared
        
        let urlBuilder = GoogleBooksURLBuilder(
            apiKey: ""
        )
        let network = NetworkInterface.Default(urlSession: urlSession)
        let bookSearchDatasource = GoogleBooksDataSource(network: network, urlBuilder: urlBuilder)
        let bookSearchRepository = GoogleBookSearchRepository(datasource: bookSearchDatasource)
                
        let readingListDatasource = ReadingListDatasource.Default(modelContext: requestValue.modelContext)
        let readingListRepository = ReadingListRepository.Default(datasource: readingListDatasource)
        
        // Use cases
        let fetchBooksUseCase = FetchBooksUseCase(repository: bookSearchRepository)
        let addReadingListItemUseCase = AddReadingListItemUseCase(repository: readingListRepository)
        let errorLogger = CrashlyticsLogger()
        
        let viewModel = BookSearchView.ViewModel(
            fetchBooksUseCase: fetchBooksUseCase,
            addReadingListItemUseCase: addReadingListItemUseCase,
            errorLogger: errorLogger
        )
        return BookSearchView(viewModel: viewModel)
    }
    
    struct RequestValues {
        let modelContext: ModelContext
    }
}
