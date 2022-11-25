//
//  CategoryTest.swift
//  ArticlesTests
//
//  Created by Sofien Benharchache on 14/11/2022.
//

import XCTest
@testable import Articles

final class CategoryTest: XCTestCase {
    func testDecodingCategoryMissingId() {
        XCTAssertThrowsError(try JSONDecoder()
            .decode(CategoryData.self, from: jsonCategoryMissingId)) { error in
                if case .keyNotFound(let key, _)? = error as? DecodingError {
                    XCTAssertEqual("id", key.stringValue)
                } else {
                    XCTFail("Expected '.keyNotFound' but got \(error)")
                }
        }
    }
    
    func testDecodingCategoryMissingName() {
        XCTAssertThrowsError(try JSONDecoder()
            .decode(CategoryData.self, from: jsonCategoryMissingName)) { error in
                if case .keyNotFound(let key, _)? = error as? DecodingError {
                    XCTAssertEqual("name", key.stringValue)
                } else {
                    XCTFail("Expected '.keyNotFound' but got \(error)")
                }
        }
    }
    
    func testDecodingCategoryNoThrow() {
        XCTAssertNoThrow(try JSONDecoder().decode(CategoryData.self, from: jsonCategory))
    }
    
    func testDecodingCategoryData() {
        XCTAssertEqual(category, try JSONDecoder().decode(CategoryData.self, from: jsonCategory))
    }
}

// MARK: - Json Data.

private let jsonCategoryMissingId = Data("""
{
    "name": "Véhicule"
}
""".utf8)

private let jsonCategoryMissingName = Data("""
{
    "id": 1
}
""".utf8)

private let category = CategoryData(id: 1, name: "Véhicule")
private let jsonCategory = Data("""
{
    "id": 1,
    "name": "Véhicule"

}
""".utf8)

