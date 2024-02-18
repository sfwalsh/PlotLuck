//
//  UseCase.swift
//  PlotLuck
//
//  Created by Stephen Walsh on 12/02/2024.
//

import Foundation

// The generic use case protocol
protocol UseCase {
    associatedtype RequestType
    
    // note that responseType can be void,
    // for scenarios where no object is expected in the success case
    associatedtype ResponseType
    
    func execute(for request: RequestType) async -> Result<ResponseType, Error>
}
