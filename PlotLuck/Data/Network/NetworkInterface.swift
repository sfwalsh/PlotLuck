//
//  NetworkInterface.swift
//  PlotLuck
//
//  Created by Stephen Walsh on 14/02/2024.
//

import Foundation

protocol NetworkInterface {
    typealias Default = DefaultNetworkInterface
    func fetchData<T: Decodable>(with request: URLRequest) async throws -> T
}

struct DefaultNetworkInterface: NetworkInterface {
    
    let urlSession: URLSession
    
    func fetchData<T>(with request: URLRequest) async throws -> T where T : Decodable {
        let (data, _) = try await urlSession.data(for: request)
        return try JSONDecoder().decode(T.self, from: data)
    }
}
