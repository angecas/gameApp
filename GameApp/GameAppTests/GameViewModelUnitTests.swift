//
//  GameViewModelUnitTests.swift
//  GameAppTests
//
//  Created by Angélica Rodrigues on 04/03/2024.
//

import Foundation
import XCTest
@testable import GameApp

class GameViewModelTests: XCTestCase {
    
    var viewModel: GameViewModel!
    var mockGame: Game!
    
    override func setUp() {
        super.setUp()
        
        guard let jsonURL = Bundle(for: type(of: self)).url(forResource: "GameModelMock", withExtension: "json"),
              let jsonData = try? Data(contentsOf: jsonURL) else {
            XCTFail("Failed to locate or read GameModelMock.json in Mocks folder")
            return
        }
        
        do {
            mockGame = try JSONDecoder().decode(Game.self, from: jsonData)
            viewModel = GameViewModel(game: mockGame)
        } catch {
            XCTFail("Failed to decode mock Game: \(error)")
        }
    }
func testupdatedDate() {
    let expectedUpdatedString = "Dec 16, 2023"
    
    let updatedString = mockGame.updatedToString()

        XCTAssertEqual(updatedString, expectedUpdatedString)
    }


func testReleasedDate() {

    let releasedString = "Feb 8, 2022"
    
    let releasedDate = mockGame.releasedToString()

        XCTAssertEqual(releasedDate, releasedString)
    }

func testRatingToString() {
    let expectedTuple = " 4.0 / 5.0"
    
    let rating = mockGame.ratingsToString()

        XCTAssertEqual(rating, expectedTuple)
    }
    
}
