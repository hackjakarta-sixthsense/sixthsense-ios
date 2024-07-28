//
//  CGFLoat+.swift
//  GrabClone
//
//  Created by Ardyan Atmojo on 12/07/24.
//

import UIKit

extension CGFloat {
    
    enum InsetSize: CGFloat {
        case smallest = 4
        case xSmall = 8
        case small = 12
        case body = 16
        case medium = 20
        case mediumLarge = 24
        case large = 32
        case xLarge = 40
        case largest = 48
    }
    
    static func apply(insets size: InsetSize) -> CGFloat {
        return size.rawValue
    }
    
    enum IconSize: CGFloat {
        case smallest = 16
        case small = 20
        case body = 24
        case medium = 30
        case large = 40
        case xLarge = 48
    }
    
    static func apply(iconSize size: IconSize) -> CGFloat {
        return size.rawValue
    }
    
    enum ContentSize: CGFloat {
        case smallRectHeight = 36
        case rectHeight = 56
        case largeRectHeight = 76
        case buttonHeight = 48
        case tabbarHeight = 61
        case actionBottomViewHeight = 320
    }
    
    static func apply(contentSize size: ContentSize) -> CGFloat {
        return size.rawValue
    }
    
    enum DeviceSizes {
        case statusBarHeight
        case bottomSafeAreaHeight
        case screenWidth
        case screenHeight
    }
    
    static func apply(currentDevice size: DeviceSizes) -> CGFloat {
        let window = UIApplication.shared.windows.first
        switch size {
        case .statusBarHeight:
            return window?.safeAreaInsets.top ?? 0
        case .bottomSafeAreaHeight:
            return window?.safeAreaInsets.bottom ?? 0
        case .screenWidth:
            return window?.screen.bounds.width ?? 0
        case .screenHeight:
            return window?.screen.bounds.height ?? 0
        }
    }
}
