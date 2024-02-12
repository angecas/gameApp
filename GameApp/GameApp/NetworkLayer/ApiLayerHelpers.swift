//
//  ApiLayerHelpers.swift
//  GameApp
//
//  Created by Angélica Rodrigues on 03/02/2024.
//

import Foundation

typealias Parameters = [String: Any]
let commonPath = "https://api.rawg.io/api"
//let apiKey = "ce61197ae53845159f4f3a9db365fbaf"
//let apiKey = ProcessInfo.processInfo.environment["RAWG_API_KEY"] ?? ""


enum HTTPMethod: String {
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
        
        guard let apiKey = Bundle.main.path(forResource: "APIKey", ofType: "plist"),
            let contents = NSDictionary(contentsOfFile: apiKey),
            let apiKey = contents["APIKey"] as? String else {
          fatalError("APIKey.plist not found or does not contain a valid APIKey")
      }

        
        urlComponents.queryItems = [
            URLQueryItem(name: "key", value: apiKey),
            URLQueryItem(name: "page", value: "\(endpoint.page)"),
            URLQueryItem(name: "page_size", value: "\(endpoint.pageSize)")
        ]
        
        if let parameters = endpoint.parameters {
            for (key, value) in parameters {
                if let stringValue = "\(value)" as? String {
                    urlComponents.queryItems?.append(URLQueryItem(name: key, value: stringValue))
                } else {
                }
            }
        }

        guard let url = urlComponents.url else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: url)
        
        request.httpMethod = endpoint.HTTPMethod.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let decoder = JSONDecoder()
        let response = try decoder.decode(T.self, from: data)
        return response
    }
}
enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case requestFailed
}

protocol EndpointDescriptor {
    var path: String { get }
    var HTTPMethod: HTTPMethod { get }
    var parameters: Parameters? { get }
    var body: Data? { get }
    var page: Int { get }
    var pageSize: Int { get }
}

extension EndpointDescriptor {
    var parameters: Parameters? {
        return nil
    }
}
