//
//  UpdateReadingListItemUseCase.swift
//  PlotLuck
//
//  Created by Stephen Walsh on 13/02/2024.
//

import Foundation

struct UpdateReadingListItemUseCase: UseCase {
    typealias RequestType = ReadingListUpdateModel
    typealias ResponseType = Void
    
    private let repository: ReadingListRepository
    
    init(repository: ReadingListRepository) {
        self.repository = repository
    }
    
    func execute(for request: ReadingListUpdateModel) async -> Result<Void, Error> {
        do {
            try await repository.update(updateModel: request)
            return .success(Void())
        } catch {
            return .failure(error)
        }
    }
}
