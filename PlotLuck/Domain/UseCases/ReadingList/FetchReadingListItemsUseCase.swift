//
//  FetchReadingListItemsUseCase.swift
//  PlotLuck
//
//  Created by Stephen Walsh on 13/02/2024.
//

import Foundation

struct FetchReadingListItemsUseCase: UseCase {
    typealias RequestType = RequestValues
    typealias ResponseType = [ReadingListItem]
    
    private let repository: ReadingListRepository
    
    init(repository: ReadingListRepository) {
        self.repository = repository
    }
    
    func execute(for request: RequestValues = .init()) async -> Result<[ReadingListItem], Error> {
        do {
            let items = try await repository.fetchItems()
            return .success(items)
        } catch {
            return .failure(error)
        }
    }
}

extension FetchReadingListItemsUseCase {
    struct RequestValues {
        // filtering options could be passed in here if time allows
    }
}
