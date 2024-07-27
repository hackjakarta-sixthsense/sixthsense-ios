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
    
    static func apply(url: String) -> UIImage? {
        var imgResult: UIImage?
        let imgCache = NSCache<AnyObject, AnyObject>()
        
        if let imgFromCache = imgCache.object(forKey: url as AnyObject) as? UIImage {
            imgResult = imgFromCache
        }
        
        ApiRequest.shared.request(url, method: .get) {
            if let data = $0.data, let image = UIImage(data: data) {
                imgCache.setObject(image, forKey: url as AnyObject)
                imgResult = image
            }
        }
        
        return imgResult
    }
}
