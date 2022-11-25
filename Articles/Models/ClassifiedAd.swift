//
//  ClassifiedAd.swift
//  Articles
//
//  Created by Sofien Benharchache on 14/11/2022.
//

import Foundation

// MARK: - Classified ads
struct ClassifiedAd: Hashable {
    let id: Int
    let title: String
    let category: Category
    var creationDate: String
    let description: String
    var imagesURL: ImagesURL
    let isUrgent: Bool
    let price: Float
    let siret: String?
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
        hasher.combine(title)
        hasher.combine(category)
        hasher.combine(creationDate)
        hasher.combine(description)
        hasher.combine(imagesURL)
        hasher.combine(isUrgent)
        hasher.combine(price)
        hasher.combine(siret)
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case category = "category_id"
        case creationDate = "creation_date"
        case description
        case imagesURL = "images_url"
        case isUrgent = "is_urgent"
        case price
        case siret
    }
    
    lazy var date: Date? = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Date.format
        return dateFormatter.date(from: creationDate)
    }()
    
    var identifier: UUID { return UUID() }
}

// MARK: - ClassifiedAd, Codable, Equatable
extension ClassifiedAd: Codable, Equatable {
    /*static func == (lhs: ClassifiedAd, rhs: ClassifiedAd) -> Bool {
        return lhs.identifier == rhs.identifier
    }*/
}

// MARK: - ClassifiedAd, calculated properties
extension ClassifiedAd {
    var formattedPrice: String {
        return NumberFormatter.localizedString(from: NSNumber(value: price), number: .currency)
    }
}

extension ClassifiedAd: Comparable {
    static func < (lhs: ClassifiedAd, rhs: ClassifiedAd) -> Bool {
        var ldate = lhs
        var rdate = rhs
        guard let ldate = ldate.date,
              let rdate = rdate.date
        else { return false }
        return ldate < rdate
    }
}


