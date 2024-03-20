//
//  ApiConfig.swift
//  GameApp
//
//  Created by Angélica Rodrigues on 11/02/2024.
//

import Foundation

protocol APIKeyable {
    var API_KEY : String { get }
}

class APIKeyManager: APIKeyable {
    static let shared = APIKeyManager()
    
    let dic: NSDictionary?

    init() {
        guard let path = Bundle.main.path(forResource: "Apikey", ofType: "plist"),
              let plistDic = NSDictionary(contentsOfFile: path) else { fatalError("Failed to load Apikey.plist") }
        
        self.dic = plistDic
    }
    
    var API_KEY: String {
        guard let apiKey = dic?.object(forKey: "API_KEY") as? String else {
            fatalError("API_KEY not found or invalid in Apikey.plist")
        }
        return apiKey
    }

}
