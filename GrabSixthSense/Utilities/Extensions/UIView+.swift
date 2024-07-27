//
//  UIView+.swift
//  GrabSixthSense
//
//  Created by Ardyan Atmojo on 27/07/24.
//

import UIKit

extension UIView {
    
    func constraints(
        top: NSLayoutYAxisAnchor? = nil, leading: NSLayoutXAxisAnchor? = nil,
        bottom: NSLayoutYAxisAnchor? = nil, trailing: NSLayoutXAxisAnchor? = nil,
        centerX: (anchor: NSLayoutXAxisAnchor, insets: CGFloat)? = nil,
        centerY: (anchor: NSLayoutYAxisAnchor, insets: CGFloat)? = nil,
        padding: UIEdgeInsets = .zero, width: CGFloat = .zero,
        height: CGFloat = .zero, customAnchors: [NSLayoutConstraint]? = nil
    ) {
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: padding.top).isActive = true
        }
        
        if let leading = leading {
            leadingAnchor.constraint(equalTo: leading, constant: padding.left).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom).isActive = true
        }
        
        if let trailing = trailing {
            trailingAnchor.constraint(equalTo: trailing, constant: -padding.right).isActive = true
        }
        
        if let centerX = centerX {
            centerXAnchor.constraint(equalTo: centerX.anchor, constant: centerX.insets).isActive = true
        }
        
        if let centerY = centerY {
            centerYAnchor.constraint(equalTo: centerY.anchor, constant: centerY.insets).isActive = true
        }
        
        if width != .zero {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if height != .zero {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
        
        if let customAnchors = customAnchors {
            NSLayoutConstraint.activate(customAnchors)
        }
    }
    
    func addSubviews(_ subview: [UIView]) {
        subview.forEach { [weak self] childView in
            self?.addSubview(childView)
        }
    }
}
