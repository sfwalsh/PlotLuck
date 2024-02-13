//
//  ViewFactory.swift
//  PlotLuck
//
//  Created by Stephen Walsh on 13/02/2024.
//

import Foundation

protocol ViewFactory {
    associatedtype RequestValueType
    associatedtype ViewType
    
    func create(for requestValue: RequestValueType) -> ViewType
}
