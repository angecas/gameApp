//
//  ApiConfig.swift
//  GameApp
//
//  Created by Angélica Rodrigues on 11/02/2024.
//

import Foundation

class APIKeyManager {
    static let shared = APIKeyManager()

    var apiKey: String?

    private init() {
        if let path = Bundle.main.path(forResource: "APIKey", ofType: "plist"),
           let apiKeyDictionary = NSDictionary(contentsOfFile: path),
           let apiKey = apiKeyDictionary["APIKey"] as? String {
            self.apiKey = apiKey
        }
    }
}
