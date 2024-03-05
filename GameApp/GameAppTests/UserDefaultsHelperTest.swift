//
//  UserDefaultsHelperTest.swift
//  GameAppTests
//
//  Created by Angélica Rodrigues on 04/03/2024.
//

import Foundation
import XCTest
@testable import GameApp

class UserDefaultsHelperTests: XCTestCase {
    
    var mockUserDefaults: MockUserDefaults!

    override func setUp() {
        super.setUp()

        mockUserDefaults = MockUserDefaults()
        UserDefaultsHelper.setUserDefaults(mockUserDefaults)
    }

    func testGetSelectedGenre() {
           // Set up
           let genreId = 42
           mockUserDefaults.set(String(genreId), forKey: "selectedGenre")

           // Test
           let result = UserDefaultsHelper.getSelectedGenre()

           // Assert
           XCTAssertEqual(result, genreId)
       }

       func testSetSelectedGenre() {
           // Set up
           let genreId = 42

           // Test
           UserDefaultsHelper.setSelectedGenre(genreId: genreId)

           // Assert
           XCTAssertEqual(mockUserDefaults.string(forKey: "selectedGenre"), String(genreId))
       }

       func testRemoveSelectedGenre() {
           // Set up
           mockUserDefaults.set("42", forKey: "selectedGenre")

           // Test
           UserDefaultsHelper.removeSelectedGenre()

           // Assert
           XCTAssertNil(mockUserDefaults.string(forKey: "selectedGenre"))
       }}
