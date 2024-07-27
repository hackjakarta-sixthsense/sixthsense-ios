//
//  UIFont+.swift
//  GrabClone
//
//  Created by Ardyan Atmojo on 12/07/24.
//

import UIKit

extension UIFont {
    
    enum FontType: String {
        case light = "SanomatSans-Light"
        case regular = "SanomatSans-Regular"
        case medium = "SanomatSans-Medium"
        case bold = "SanomatSans-Bold"
    }
    
    enum FontSize: CGFloat {
        case caption = 12
        case subhead = 14
        case body = 16
        case title3 = 21
        case title2 = 24
        case title = 28
    }
    
    static func apply(_ font: FontType, size: FontSize) -> UIFont {
        return .init(name: font.rawValue, size: size.rawValue)!
    }
}
