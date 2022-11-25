//
//  UIColor+Extension.swift
//  Articles
//
//  Created by Sofien Benharchache on 25/11/2022.
//

import UIKit

extension UIColor {
    static let mainBlue = UIColor.hexColor("#2B2D42")
    
    static func hexColor(_ hex: String) -> UIColor {
        var cString: String = hex
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .uppercased()

        if cString.hasPrefix("#") {
            cString.removeFirst()
        }

        if (cString.count) != 6 {
            return .gray
        }

        var rgbValue: UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: 1.0
        )
    }
}
