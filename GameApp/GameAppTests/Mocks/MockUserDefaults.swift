//
//  MockUserDefaults.swift
//  GameAppTests
//
//  Created by Angélica Rodrigues on 04/03/2024.
//

import Foundation
@testable import GameApp

class MockUserDefaults: UserDefaultsProtocol {
    private var storage: [String: Any] = [:]

    func string(forKey defaultName: String) -> String? {
        return storage[defaultName] as? String
    }

    func set(_ value: Any?, forKey defaultName: String) {
        storage[defaultName] = value
    }

    func removeObject(forKey defaultName: String) {
        storage.removeValue(forKey: defaultName)
    }

    func synchronize() -> Bool {
        return true
    }
}
