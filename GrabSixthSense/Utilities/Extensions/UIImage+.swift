//
//  UIImage+.swift
//  GrabSixthSense
//
//  Created by Ardyan Atmojo on 27/07/24.
//

import UIKit
import Alamofire

extension UIImage {
    
    static func apply(assets: Assets) -> UIImage? {
        return .init(named: assets.rawValue)
    }
}
