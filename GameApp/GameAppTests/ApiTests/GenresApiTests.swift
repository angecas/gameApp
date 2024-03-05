//
//  GenresApiTests.swift
//  GameAppTests
//
//  Created by Angélica Rodrigues on 04/03/2024.
//

import Foundation
import XCTest
@testable import GameApp

class GenresApiTests: XCTestCase {
    
    func testFetchListOfGamesGenres() {
        let api = GenresApi.fetchListOfGamesGenres(page: 1)
        
        XCTAssertEqual(api.page, 1)
        XCTAssertEqual(api.pageSize, 9)
        XCTAssertNil(api.body)
        XCTAssertEqual(api.HTTPMethod, .get)
        XCTAssertNil(api.parameters)
        XCTAssertEqual(api.path, "https://api.rawg.io/api/genres")
    }

    func testFetchGenresById() {
        let api = GenresApi.fetchGenresById(id: 42)
        
        XCTAssertEqual(api.page, 10)
        XCTAssertEqual(api.pageSize, 9)
        XCTAssertNil(api.body)
        XCTAssertEqual(api.HTTPMethod, .get)
        XCTAssertNil(api.parameters)
        XCTAssertEqual(api.path, "https://api.rawg.io/api/genres/42")
    }
}
