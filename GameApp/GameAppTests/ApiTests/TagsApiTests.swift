//
//  TagsApiTests.swift
//  GameAppTests
//
//  Created by Angélica Rodrigues on 04/03/2024.
//

import Foundation
import XCTest
@testable import GameApp

class TagsApiTests: XCTestCase {
    
    func testFetchListOfTags() {
        let api = TagsApi.fetchListOfTags(page: 1)
        
        XCTAssertEqual(api.page, 1)
        XCTAssertEqual(api.pageSize, 9)
        XCTAssertNil(api.body)
        XCTAssertEqual(api.HTTPMethod, .get)
        XCTAssertNil(api.parameters)
        XCTAssertEqual(api.path, "https://api.rawg.io/api/tags")
    }
}
