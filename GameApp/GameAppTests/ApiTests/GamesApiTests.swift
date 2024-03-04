//
//  GameApiTests.swift
//  GameAppTests
//
//  Created by Angélica Rodrigues on 04/03/2024.
//

import Foundation
import XCTest
@testable import GameApp

class GamesApiTests: XCTestCase {

    func testFetchListOfGamesEndpoint() {
        // Arrange
        let genres = 1
        let freeSearch: String? = "example"
        let preciseSearch = true
        let page = 3
        let expectedPath = "https://api.rawg.io/api/games"
        
        // Act
        let endpoint = GamesApi.fetchListOfGames(genres: genres, freeSearch: freeSearch, preciseSearch: preciseSearch, page: page)
        
        // Assert
        XCTAssertEqual(endpoint.page, page)
        XCTAssertEqual(endpoint.pageSize, 9)
        XCTAssertNil(endpoint.body)
        XCTAssertEqual(endpoint.HTTPMethod, .get)
        XCTAssertEqual(endpoint.path, expectedPath)
    }

    func testFetchGameTrailersEndpoint() {
        // Arrange
        let gameId = 123
        let expectedPath = "https://api.rawg.io/api/games/\(gameId)/movies"
        let expectedParameters: Parameters = ["id": gameId]
        
        // Act
        let endpoint = GamesApi.fetchGameTrailers(gameId: gameId)
                
        // Assert
        XCTAssertEqual(endpoint.page, 1)
        XCTAssertEqual(endpoint.pageSize, 9)
        XCTAssertNil(endpoint.body)
        XCTAssertEqual(endpoint.HTTPMethod, .get)
        XCTAssertEqual(endpoint.path, expectedPath)
        XCTAssertEqual(endpoint.parameters as! [String : Int], ["id": 123])
    }
}
