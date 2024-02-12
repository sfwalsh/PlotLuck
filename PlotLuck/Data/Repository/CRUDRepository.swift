//
//  CRUDRepository.swift
//  PlotLuck
//
//  Created by Stephen Walsh on 12/02/2024.
//

import Foundation

protocol CRUDRepository {
    associatedtype Item
    func addItem(item: Item)
}
