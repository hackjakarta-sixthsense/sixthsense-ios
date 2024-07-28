//
//  UIStackView+.swift
//  GrabSixthSense
//
//  Created by Ardyan Atmojo on 28/07/24.
//

import UIKit

extension UIStackView {
    
    func addArrangedSubviews(_ views: [UIView]) {
        views.forEach { [weak self] view in
            self?.addArrangedSubview(view)
        }
    }
}
