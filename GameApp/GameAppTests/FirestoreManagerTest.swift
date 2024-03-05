//
//  FirestoreManagerTest.swift
//  GameAppTests
//
//  Created by Angélica Rodrigues on 04/03/2024.
//

import Foundation
import XCTest
@testable import GameApp

class FirestoreManagerTest: XCTestCase {
    
    var mockFirestoreManager: MockFirestoreManager!
    
    override func setUp() {
        super.setUp()
        mockFirestoreManager = MockFirestoreManager()
    }

    func testSaveFavorites() {
        // Set up
        let expectation = self.expectation(description: "SaveFavorites")
        let id = 41
        let name = "Action"
        
        // Test
        mockFirestoreManager.saveFavorites(id: id, name: name) { error in
            // Assert
            XCTAssertNil(error)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testGetFavoriteGenres() {
        // Set up
        let expectation = self.expectation(description: "GetFavoriteGenres")
        
        // Test
        mockFirestoreManager.getFavoriteGenres { favoriteGenres, error in
            // Assert
            XCTAssertNil(error)
            XCTAssertEqual(favoriteGenres.count, 0)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testRemoveAllFavorites() {
        // Set up
        let expectation = self.expectation(description: "RemoveAllFavorites")
        
        // Test
        mockFirestoreManager.removeAllFavorites { error in
            // Assert
            XCTAssertNil(error)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
}
