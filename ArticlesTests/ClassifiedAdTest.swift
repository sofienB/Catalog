//
//  ClassifiedAdTest.swift
//  ArticlesTests
//
//  Created by Sofien Benharchache on 14/11/2022.
//

import XCTest
@testable import Articles

final class ClassifiedAdTest: XCTestCase {
    func testDecodingClassifiedAdNoThrow() {
        XCTAssertNoThrow(try JSONDecoder().decode(ClassifiedAd.self, from: jsonClassifiedAd))
    }
    
    func testDecodingClassifiedAd() {
        XCTAssertEqual(classifiedAd, try JSONDecoder().decode(ClassifiedAd.self, from: jsonClassifiedAd))
    }

    func testDecodingClassifiedAd_CheckValue() {
        do {
            let decodedClassifiedAd = try JSONDecoder()
                .decode(ClassifiedAd.self, from: jsonClassifiedAd)
            XCTAssertEqual(decodedClassifiedAd.id, 1670293150)
            XCTAssertEqual(decodedClassifiedAd.title, "Sacs cartable")
            XCTAssertEqual(decodedClassifiedAd.category, Category(rawValue:2) ?? .unknown)
            XCTAssertEqual(decodedClassifiedAd.creationDate, "2019-11-05T15:53:27+0000")
            XCTAssertEqual(decodedClassifiedAd.description, "De marque new look. Très bon état.")
            XCTAssertEqual(decodedClassifiedAd.imagesURL, classifiedAd.imagesURL)
            XCTAssertEqual(decodedClassifiedAd.imagesURL.small, classifiedAd.imagesURL.small)
            XCTAssertEqual(decodedClassifiedAd.imagesURL.thumb, classifiedAd.imagesURL.thumb)
            XCTAssertEqual(decodedClassifiedAd.isUrgent, true)
            XCTAssertEqual(decodedClassifiedAd.price, 5.00)
            XCTAssertEqual(decodedClassifiedAd.siret, "397 594 922")

            
            XCTAssertNotNil(decodedClassifiedAd.imagesURL.small)
            XCTAssertNotNil(decodedClassifiedAd.imagesURL.thumb)

            XCTAssertTrue(decodedClassifiedAd.imagesURL.small!.isURL)
            XCTAssertTrue(decodedClassifiedAd.imagesURL.thumb!.isURL)
        } catch {
            XCTFail("Got error: \(error)")
        }
    }
    
    func testDecodingClassifiedAd_CheckCalculatedValue() {
        do {
            var decodedClassifiedAd = try JSONDecoder().decode(ClassifiedAd.self, from: jsonClassifiedAd)
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = Date.format
            let calculatedDate = dateFormatter.date(from: "2019-11-05T15:53:27+0000")
            XCTAssertEqual(decodedClassifiedAd.date, calculatedDate)
        } catch {
            XCTFail("Got error: \(error)")
        }
    }
    
    func testDecodingClassifiedAd_NoSiret() {
        do {
            let decodedClassifiedAd = try JSONDecoder().decode(ClassifiedAd.self, from: jsonClassifiedAdNoSiret)
            
            XCTAssertEqual(decodedClassifiedAd.id, 1670293150)
            XCTAssertEqual(decodedClassifiedAd.title, "Sacs cartable")
            XCTAssertEqual(decodedClassifiedAd.category, Category(rawValue:2) ?? .unknown)
            XCTAssertEqual(decodedClassifiedAd.creationDate, "2019-11-05T15:53:27+0000")
            XCTAssertEqual(decodedClassifiedAd.description, "De marque new look. Très bon état.")
            XCTAssertEqual(decodedClassifiedAd.imagesURL, classifiedAd.imagesURL)
            XCTAssertEqual(decodedClassifiedAd.imagesURL.small, classifiedAd.imagesURL.small)
            XCTAssertEqual(decodedClassifiedAd.imagesURL.thumb, classifiedAd.imagesURL.thumb)
            XCTAssertEqual(decodedClassifiedAd.isUrgent, true)
            XCTAssertEqual(decodedClassifiedAd.price, 5.00)
            
            XCTAssertNil(decodedClassifiedAd.siret)
        } catch {
            XCTFail("Got error: \(error)")
        }
    }
}

// MARK: - Json Data.

private let classifiedAd = ClassifiedAd(
    id: 1670293150,
    title: "Sacs cartable",
    category: Category(rawValue:2) ?? .unknown,
    creationDate: "2019-11-05T15:53:27+0000",
    description: "De marque new look. Très bon état.",
    imagesURL: ImagesURL(small: "https://raw.githubusercontent.com/leboncoin/paperclip/master/ad-small/946d175c391a3a352f3db93b1b5085934d7ebb17.jpg",
                          thumb: "https://raw.githubusercontent.com/leboncoin/paperclip/master/ad-thumb/946d175c391a3a352f3db93b1b5085934d7ebb17.jpg"),
    isUrgent: true,
    price: 5.00,
    siret: "397 594 922"
)

private let jsonClassifiedAd = Data("""
{
      "id":1670293150,
      "category_id":2,
      "title":"Sacs cartable",
      "description":"De marque new look. Très bon état.",
      "price":5.00,
      "images_url":{
         "small":"https://raw.githubusercontent.com/leboncoin/paperclip/master/ad-small/946d175c391a3a352f3db93b1b5085934d7ebb17.jpg",
         "thumb":"https://raw.githubusercontent.com/leboncoin/paperclip/master/ad-thumb/946d175c391a3a352f3db93b1b5085934d7ebb17.jpg"
      },
      "creation_date":"2019-11-05T15:53:27+0000",
      "is_urgent":true,
      "siret":"397 594 922"
}
""".utf8)

private let jsonClassifiedAdNoSiret = Data("""
{
      "id":1670293150,
      "category_id":2,
      "title":"Sacs cartable",
      "description":"De marque new look. Très bon état.",
      "price":5.00,
      "images_url":{
         "small":"https://raw.githubusercontent.com/leboncoin/paperclip/master/ad-small/946d175c391a3a352f3db93b1b5085934d7ebb17.jpg",
         "thumb":"https://raw.githubusercontent.com/leboncoin/paperclip/master/ad-thumb/946d175c391a3a352f3db93b1b5085934d7ebb17.jpg"
      },
      "creation_date":"2019-11-05T15:53:27+0000",
      "is_urgent":true
}
""".utf8)
