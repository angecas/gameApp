//
//  ApiLayerHelpers.swift
//  GameApp
//
//  Created by Angélica Rodrigues on 03/02/2024.
//

import Foundation

public typealias Parameters = [String: Any]
public let commonPath = "https://api.rawg.io/api"

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case delete  = "DELETE"
    case put = "PUT"
}

class SessionProvider {
    func request<T: Decodable>(_ endpoint: EndpointDescriptor, responseType: T.Type) async throws -> T {
        
        guard let url = URL(string: endpoint.path) else {
            throw NetworkError.invalidURL
        }

        let (data, _) = try await URLSession.shared.data(from: url)
        let decoder = JSONDecoder()
        let response = try decoder.decode(T.self, from: data)
        return response
    }
}

enum NetworkError: Error {
    case invalidURL
}

public protocol EndpointDescriptor {

    var path: String { get }
    var HTTPMethod: HTTPMethod { get }
    var parameters: Parameters? { get }
    var body: Data? { get }
}
