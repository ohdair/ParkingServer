//
//  NetworkRouter.swift
//  ParkingServer
//
//  Created by 박재우 on 2023/06/08.
//

import Foundation

class NetworkRouter {

    private let session = URLSession.shared

    func fetch(_ request: URLRequest) async throws -> Data? {
        let (data, response) = try await session.data(for: request)
        guard let status = (response as? HTTPURLResponse)?.statusCode, 200...299 ~= status else {
            throw NetworkError.invalidServerResponse
        }
        return data
    }

    func fetchItem<T: Decodable>(with request: URLRequest, model: T.Type) async throws -> T? {
        guard let data = try await fetch(request) else {
            throw NetworkError.invalidData
        }
        let decodedData = try JSONDecoder().decode(T.self, from: data)
        return decodedData
    }
}
