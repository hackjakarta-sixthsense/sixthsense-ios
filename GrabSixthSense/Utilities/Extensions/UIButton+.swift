//
//  UIButton+.swift
//  GrabClone
//
//  Created by Ardyan Atmojo on 19/07/24.
//

import UIKit

extension UIButton {
    
    func icon(source: UIImage?) {
        setImage(source?.withRenderingMode(.alwaysTemplate), for: .normal)
        contentMode = .scaleAspectFit
        tintColor = .black
    }
}
