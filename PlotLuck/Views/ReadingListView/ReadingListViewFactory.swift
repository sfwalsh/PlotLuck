//
//  ReadingListViewFactory.swift
//  PlotLuck
//
//  Created by Stephen Walsh on 13/02/2024.
//

import Foundation
import SwiftData

struct ReadingListViewFactory: ViewFactory {
    typealias RequestValueType = RequestValues
    typealias ViewType = ReadingListView
    
    func create(for requestValues: RequestValueType) -> ViewType {
        let modelContext = requestValues.modelContext
        let datasource = LocalReadingListDatasource(modelContext: modelContext)
        let repository = DefaultReadingListRepository(datasource: datasource)
        let addReadingListItemUseCase = AddReadingListItemUseCase(repository: repository)
        let errorLogger = CrashlyticsLogger()
        let viewModel = ReadingListView.ViewModel(
            addReadingListItem: addReadingListItemUseCase,
            errorLogger: errorLogger
        )
        return ReadingListView(viewModel: viewModel)
    }
    
    struct RequestValues {
        let modelContext: ModelContext
    }
}
