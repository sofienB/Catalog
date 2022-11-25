//
//  Array+Extension.swift
//  Articles
//
//  Created by Sofien Benharchache on 17/11/2022.
//

import Foundation

extension Array where Element == ClassifiedAd {
    // Sort current array by date.
    mutating func sort() {
        self = self.sorted { $0.isUrgent && $1.isUrgent ? $0 < $1 : $0.isUrgent ? true : $1.isUrgent ? false : $0 < $1 }
    }

    // Find all data by categry.
    func sub(category: Category) -> [Element] {
        return self.filter { $0.category == category }
    }

    // Find data by id.
    func find(by id: Int) -> Element? {
        return self.first { $0.id == id }
    }

    // Find all data by urgent.
    var urgents: [Element] {
        get { return self.filter { $0.isUrgent } }
    }
}
