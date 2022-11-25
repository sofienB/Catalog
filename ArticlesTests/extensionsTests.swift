//
//  extensionsTests.swift
//  ArticlesTests
//
//  Created by Sofien Benharchache on 16/11/2022.
//

import XCTest
@testable import Articles

final class extensionsTests: XCTestCase {
    func testExtensionString_isURL() throws {
        let stringURL = "http://apple.com"
        let stringURLS = "https://apple.com"
        let stringNoURL = "http/noURL"
        let stringEmpty = ""
        var stringNil:String? = nil
        
        XCTAssertTrue(stringURL.isURL)
        XCTAssertTrue(stringURLS.isURL)

        XCTAssertFalse(stringNoURL.isURL)
        XCTAssertFalse(stringEmpty.isURL)
        
        XCTAssertNil(stringNil?.isURL)
    }
    
    func testExtensionString_Date() throws {
        let date = "2019-11-05T15:53:27+0000".toDate

        XCTAssertNotNil(date)
        XCTAssertEqual(date?.formattedDate, "11/5/2019")
    }
}
