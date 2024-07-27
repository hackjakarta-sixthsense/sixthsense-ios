//
//  OvalButton.swift
//  GrabSixthSense
//
//  Created by Muhammad Ziddan on 27/07/24.
//

import UIKit

class OvalButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.size.height / 2
    }
    
    private func setupButton() {
        layer.masksToBounds = true
    }
    
}
