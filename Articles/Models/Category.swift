//
//  Category.swift
//  Articles
//
//  Created by Sofien Benharchache on 14/11/2022.
//

import Foundation

enum Category: Int, CaseIterable, Hashable {
case unknown = 0,
     car,
     mode,
     diy,
     home,
     hobbies,
     realEstate,
     book,
     highTech,
     service,
     pets,
     children

    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }

    private var identifier: UUID { return UUID() }
}

extension Category: Codable, Equatable {
    
}

extension Category {
    var description: String {
        switch self {
        case .unknown:
            return NSLocalizedString("unknown", comment: "")
        case .car:
            return NSLocalizedString("Véhicule", comment: "")
        case .mode:
            return NSLocalizedString("Mode", comment: "")
        case .diy:
            return NSLocalizedString("Bricolage", comment: "")
        case .home:
            return NSLocalizedString("Maison", comment: "")
        case .hobbies:
            return NSLocalizedString("Loisirs", comment: "")
        case .realEstate:
            return NSLocalizedString("Immobilier", comment: "")
        case .book:
            return NSLocalizedString("Livres/CD/DVD", comment: "")
        case .highTech:
            return NSLocalizedString("Multimédia", comment: "")
        case .service:
            return NSLocalizedString("Service", comment: "")
        case .pets:
            return NSLocalizedString("Animaux", comment: "")
        case .children:
            return NSLocalizedString("Enfants", comment: "")
        }
    }
}
