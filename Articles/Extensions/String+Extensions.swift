//
//  String+Extensions.swift
//  Articles
//
//  Created by Sofien Benharchache on 16/11/2022.
//

import UIKit

extension String {
    var isURL: Bool {
        guard let url = URL(string: self)
        else { return false }
        return UIApplication.shared.canOpenURL(url)
    }
    
    var toDate: Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Date.format
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current
        return dateFormatter.date(from: self)
    }
}
