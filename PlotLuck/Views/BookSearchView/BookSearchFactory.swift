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
        BookSearchView()
    }
    
    struct RequestValues {
        
    }
}
