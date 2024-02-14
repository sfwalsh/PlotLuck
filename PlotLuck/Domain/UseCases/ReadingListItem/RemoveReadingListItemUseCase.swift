//
//  RemoveReadingListItemUseCase.swift
//  PlotLuck
//
//  Created by Stephen Walsh on 13/02/2024.
//

import Foundation

struct RemoveReadingListItemUseCase: UseCase {
    typealias RequestType = ReadingListItem
    typealias ResponseType = Void
    
    private let repository: ReadingListRepository
    
    init(repository: ReadingListRepository) {
        self.repository = repository
    }
    
    func execute(for request: ReadingListItem) async -> Result<Void, Error> {
        do {
            try await repository.removeItem(request)
            return .success(Void())
        } catch {
            return .failure(error)
        }
    }
}
