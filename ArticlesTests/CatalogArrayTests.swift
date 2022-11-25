//
//  CatalogArrayTests.swift
//  ArticlesTests
//
//  Created by Sofien Benharchache on 17/11/2022.
//

import XCTest
@testable import Articles

final class CatalogArrayTests: XCTestCase {
    let classifiedAds = [classifiedAd_car, classifiedAd_mode, classifiedAd_diy]

    func testCatalogue_Data() throws {
        var catalog = [ClassifiedAd]()
        catalog.append(contentsOf: classifiedAds)

        XCTAssertFalse(catalog.isEmpty)
    }

    func testCatalogue_subCategory() throws {
        var catalog = [ClassifiedAd]()
        catalog.append(contentsOf: classifiedAds)

        // Check 2 data found (diy data category).
        let diy = Category.diy
        let diyCategory = catalog.sub(category: .diy)
        XCTAssertTrue(diyCategory.count == 2)
        XCTAssertTrue(diyCategory[0].category == diy)
        XCTAssertTrue(diyCategory[1].category == diy)

        // Check 1 data found (car data category).
        let car = Category.car
        let carCategory = catalog.sub(category: car)
        XCTAssertTrue(carCategory.count == 1)
        XCTAssertTrue(carCategory[0].category == car)

        // Check no data.
        let mode = Category.mode
        let modeCategory = catalog.sub(category: mode)
        XCTAssertTrue(modeCategory.isEmpty)

        // Check if no regression on main array with initial values.
        XCTAssertTrue(catalog.count == 3)
    }

    func testCatalogue_findById() throws {
        var catalog = [ClassifiedAd]()
        catalog.append(contentsOf: classifiedAds)

        let id = 1670293151
        let classifiedAd = catalog.find(by: id)

        let id_not_found = 42
        let classifiedAd_noData = catalog.find(by: id_not_found)

        // Check data found not nil.
        XCTAssertNotNil(classifiedAd)

        // Check no data found.
        XCTAssertNil(classifiedAd_noData)

        if let classifiedAd {
            // Check data found.
            XCTAssertTrue(classifiedAd.id == id)
        }
    }

    func testCatalogue_isUrgent() throws {
        var catalog = [ClassifiedAd]()
        catalog.append(contentsOf: classifiedAds)

        let urgents = catalog.urgents

        // Check found not nil.
        XCTAssertTrue(urgents.count == 2)

        // Check data are realy urgents.
        XCTAssertTrue(urgents[0].isUrgent)
        XCTAssertTrue(urgents[1].isUrgent)

        // Check data found not equals.
        XCTAssertNotEqual(urgents[0], urgents[1])
    }

    
    // Faire Element.0.isUrgent et Element.1.isUrgent
    func testCatalogue_sort() throws {
        var catalog = [ClassifiedAd]()
        catalog.append(contentsOf: classifiedAds + [classifiedAd_home])

        catalog.sort()
        
        // Check no data added or removed.
        XCTAssertTrue(catalog.count == 4)
        
        // Check if data are sorted by date.
        XCTAssertTrue(catalog[0].date! < catalog[1].date!)
        XCTAssertFalse(catalog[1].date! < catalog[2].date!)
        XCTAssertTrue(catalog[2].date! < catalog[3].date!)
        
        // Check if data are classified by urgent states.
        XCTAssertTrue(catalog[0].isUrgent)
        XCTAssertTrue(catalog[1].isUrgent)
        XCTAssertFalse(catalog[2].isUrgent)
        XCTAssertFalse(catalog[3].isUrgent)
    }
    
    // Faire Element.0.!isUrgent et Element.1.!isUrgent
    func testCatalogue_sort_urgent() throws {
        var catalog = [ClassifiedAd]()
        catalog.append(contentsOf: [
            // is not urgent
            classifiedAd_mode,
            classifiedAd_home,
            classifiedAd_children, // is urgent
            classifiedAd_service,
            // is urgent
            classifiedAd_pets,
            classifiedAd_highTech, // not urgent
            classifiedAd_car,
            classifiedAd_diy
        ])

        catalog.sort()

        // Check no data added or removed.
        XCTAssertTrue(catalog.count == 8)
        
        // Check if data are sorted by date.
        XCTAssertTrue(catalog[0].date! < catalog[1].date!)
        XCTAssertTrue(catalog[1].date! < catalog[2].date!)
        XCTAssertTrue(catalog[2].date! < catalog[3].date!)
        
        XCTAssertFalse(catalog[3].date! < catalog[4].date!)

        XCTAssertTrue(catalog[4].date! < catalog[5].date!)
        XCTAssertTrue(catalog[5].date! < catalog[6].date!)
        XCTAssertTrue(catalog[6].date! < catalog[7].date!)
        
        // Check if data are classified by urgent states.
        XCTAssertTrue(catalog[0].isUrgent)
        XCTAssertTrue(catalog[1].isUrgent)
        XCTAssertTrue(catalog[2].isUrgent)
        XCTAssertTrue(catalog[3].isUrgent)
        
        XCTAssertFalse(catalog[4].isUrgent)
        XCTAssertFalse(catalog[5].isUrgent)
        XCTAssertFalse(catalog[6].isUrgent)
        XCTAssertFalse(catalog[7].isUrgent)
    }
}

// MARK: - Json Data.
private let classifiedAd_car = ClassifiedAd(
    id: 1670293150,
    title: "Sacs cartable",
    category: .car,
    creationDate: "2023-11-05T15:53:27+0000",
    description: "De marque new look. Très bon état.",
    imagesURL: ImagesURL(small: "https://raw.githubusercontent.com/leboncoin/paperclip/master/ad-small/946d175c391a3a352f3db93b1b5085934d7ebb17.jpg",
                          thumb: "https://raw.githubusercontent.com/leboncoin/paperclip/master/ad-thumb/946d175c391a3a352f3db93b1b5085934d7ebb17.jpg"),
    isUrgent: true,
    price: 5.00,
    siret: "397 594 922"
)

private let classifiedAd_mode = ClassifiedAd(
    id: 1670293151,
    title: "mode",
    category: .diy,
    creationDate: "2666-11-05T15:53:27+0000",
    description: "De marque new look. Très bon état.",
    imagesURL: ImagesURL(small:nil, thumb: nil),
    isUrgent: false,
    price: 5.00,
    siret: "397 594 922"
)

private let classifiedAd_diy = ClassifiedAd(
    id: 1670293152,
    title: "diy",
    category: .diy,
    creationDate: "2010-12-10T15:53:27+0000",
    description: "De marque new look. Très bon état.",
    imagesURL: ImagesURL(small: nil, thumb: nil),
    isUrgent: true,
    price: 5.00,
    siret: "397 594 922"
)

private let classifiedAd_home = ClassifiedAd(
    id: 1670293153,
    title: "home",
    category: .home,
    creationDate: "2000-12-10T15:53:27+0000",
    description: "De marque new look. Très bon état.",
    imagesURL: ImagesURL(small:nil, thumb:nil),
    isUrgent: false,
    price: 5.00,
    siret: "397 594 922"
)

private let classifiedAd_highTech = ClassifiedAd(
    id: 1670293153,
    title: "highTech",
    category: .highTech,
    creationDate: "2030-12-10T15:53:27+0000",
    description: "De marque new look. Très bon état.",
    imagesURL: ImagesURL(small:nil, thumb: nil),
    isUrgent: false,
    price: 5.00,
    siret: "397 594 922"
)
private let classifiedAd_service = ClassifiedAd(
    id: 1670293153,
    title: "service",
    category: .service,
    creationDate: "2100-12-10T15:53:27+0000",
    description: "De marque new look. Très bon état.",
    imagesURL: ImagesURL(small:nil, thumb: nil),
    isUrgent: false,
    price: 5.00,
    siret: "397 594 922"
)
private let classifiedAd_pets = ClassifiedAd(
    id: 1670293153,
    title: "pets",
    category: .pets,
    creationDate: "2003-12-10T15:53:27+0000",
    description: "De marque new look. Très bon état.",
    imagesURL: ImagesURL(small:nil, thumb: nil),
    isUrgent: true,
    price: 5.00,
    siret: "397 594 922"
)
private let classifiedAd_children = ClassifiedAd(
    id: 1670293153,
    title: "children",
    category: .children,
    creationDate: "2001-2-10T15:53:27+0000",
    description: "De marque new look. Très bon état.",
    imagesURL: ImagesURL(small:nil, thumb: nil),
    isUrgent: true,
    price: 5.00,
    siret: "397 594 922"
)
