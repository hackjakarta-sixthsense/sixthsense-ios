//
//  UIImageView+.swift
//  GrabSixthSense
//
//  Created by Ardyan Atmojo on 28/07/24.
//

import UIKit

extension UIImageView {
    
    func apply(loadFrom url: String) {
        let imgCache = NSCache<AnyObject, AnyObject>()
        
        if let imgFromCache = imgCache.object(forKey: url as AnyObject) as? UIImage {
            image = imgFromCache
        }
        
        ApiRequest.shared.request(url, method: .get) { [weak self] response in
            if let data = response.data, let image = UIImage(data: data) {
                imgCache.setObject(image, forKey: url as AnyObject)
                self?.image = image
            }
        }
    }
}
