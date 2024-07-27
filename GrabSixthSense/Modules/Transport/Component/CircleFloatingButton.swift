//
//  CircleFloatingButton.swift
//  GrabSixthSense
//
//  Created by Muhammad Ziddan on 27/07/24.
//

import UIKit

class CircleFloatingButton: UIButton {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.size.width / 2
    }
    
}
