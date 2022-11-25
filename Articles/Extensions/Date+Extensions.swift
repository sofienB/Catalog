//
//  Date+Extensions.swift
//  Articles
//
//  Created by Sofien Benharchache on 14/11/2022.
//

import Foundation

extension Date {
    var formattedDate: String {
        if #available(iOS 15.0, *) {
            return self.formatted(date: .numeric, time: .omitted)
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .none
            dateFormatter.locale = .current
            dateFormatter.dateFormat = Date.format
            return dateFormatter.string(from: self)
        }
    }
    
    static var format: String {  "yyyy-MM-dd'T'HH:mm:ssZ" }
}
