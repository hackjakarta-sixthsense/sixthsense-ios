//
//  UIImage+.swift
//  GrabSixthSense
//
//  Created by Ardyan Atmojo on 27/07/24.
//

import UIKit

extension UIImage {
    
    static func apply(assets: Assets) -> UIImage? {
        return .init(named: assets.rawValue)
    }
}
