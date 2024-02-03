//
//  ApiLayerHelpers.swift
//  GameApp
//
//  Created by Angélica Rodrigues on 03/02/2024.
//

import Foundation

public typealias Parameters = [String: Any]
public let commonPath = "https://api.rawg.io/api"
public let apiKey = "ce61197ae53845159f4f3a9db365fbaf"

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case delete  = "DELETE"
    case put = "PUT"
}

class SessionProvider {
    func request<T: Decodable>(_ endpoint: EndpointDescriptor, responseType: T.Type) async throws -> T {
        guard var urlComponents = URLComponents(string: endpoint.path) else {
            throw NetworkError.invalidURL
        }

        urlComponents.queryItems = [
            URLQueryItem(name: "key", value: apiKey),
            URLQueryItem(name: "page", value: "\(endpoint.page)"),
            URLQueryItem(name: "page_size", value: "\(endpoint.pageSize)")
        ]

        guard let url = urlComponents.url else {
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
    var page: Int { get }
    var pageSize: Int { get }
}

