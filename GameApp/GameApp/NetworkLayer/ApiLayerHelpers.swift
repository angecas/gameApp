//
//  ApiLayerHelpers.swift
//  GameApp
//
//  Created by Angélica Rodrigues on 03/02/2024.
//

import Foundation

typealias Parameters = [String: Any]
let commonPath = "https://api.rawg.io/api"


enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case delete  = "DELETE"
    case put = "PUT"
}

class SessionProvider {
    func request<T: Decodable>(_ endpoint: EndpointDescriptor, responseType: T.Type) async throws -> T {
        
        let apiKey = API_ENV.API_KEY

        guard var urlComponents = URLComponents(string: endpoint.path) else {
            throw NetworkError.invalidURL
        }
                
        urlComponents.queryItems = [
            URLQueryItem(name: "key", value: apiKey),
        ]
        
        if let page = endpoint.page {
            urlComponents.queryItems?.append(URLQueryItem(name: "page", value: "\(page)"))
        }
        if let pageSize = endpoint.pageSize {
            urlComponents.queryItems?.append(URLQueryItem(name: "page_size", value: "\(pageSize)"))
        }

        if let parameters = endpoint.parameters {
            
            
            for (key, value) in parameters {
                if let stringValue = "\(value)" as? String {
                    urlComponents.queryItems?.append(URLQueryItem(name: key, value: stringValue))
                }
            }
        }

        guard let url = urlComponents.url else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.HTTPMethod.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
//                print("No valid HTTP response")
//                print("Response Data Size: \(data.count) bytes")
                throw NetworkError.invalidResponse
            }

            print("HTTP Status Code: \(httpResponse.statusCode)")

            if let jsonString = String(data: data, encoding: .utf8) {
//                print("Received JSON data:\n\(jsonString)")
            } else {
//                print("No response data")
            }

            if (200..<300).contains(httpResponse.statusCode) {
                let decoder = JSONDecoder()
                let response = try decoder.decode(T.self, from: data)
                return response
            } else {
                if let errorResponse = try? JSONDecoder().decode([String: String].self, from: data),
                   let errorMessage = errorResponse["error"] {
//                    print("API Error: \(errorMessage)")
                    throw NetworkError.apiError(errorMessage)
                } else {
                    print("Unknown API error")
                    throw NetworkError.apiError("Unknown API error")
                }
            }
        } catch {
            print("Error performing request: \(error)")
            throw error
        }
    }
}
enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case requestFailed
    case apiError(String)
    case decodingError
}

protocol EndpointDescriptor {
    var path: String { get }
    var HTTPMethod: HTTPMethod { get }
    var parameters: Parameters? { get }
    var body: Data? { get }
    var page: Int? { get }
    var pageSize: Int? { get }
}

extension EndpointDescriptor {
    var parameters: Parameters? {
        return nil
    }
}

