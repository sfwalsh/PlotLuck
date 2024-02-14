//
//  BookSearchFactory.swift
//  PlotLuck
//
//  Created by Stephen Walsh on 14/02/2024.
//

import Foundation

struct BookSearchViewFactory: ViewFactory {
    typealias RequestValueType = RequestValues
    typealias ViewType = BookSearchView
    
    func create(for requestValue: RequestValues) -> BookSearchView {
        let repository = GoogleBookSearchRepository()
        let fetchBooksUseCase = FetchBooksUseCase(repository: repository)
        let errorLogger = CrashlyticsLogger()
        
        let viewModel = BookSearchView.ViewModel(
            fetchBooksUseCase: fetchBooksUseCase,
            errorLogger: errorLogger
        )
        return BookSearchView(viewModel: viewModel)
    }
    
    struct RequestValues {
        
    }
}
