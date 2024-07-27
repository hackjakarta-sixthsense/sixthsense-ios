//
//  String+.swift
//  GrabClone
//
//  Created by Ardyan Atmojo on 21/07/24.
//

import Foundation

extension NSMutableAttributedString {
    
    func getEstimatedTextFrame(
        width: CGFloat = .apply(currentDevice: .screenWidth),
        height: CGFloat = .apply(currentDevice: .screenWidth)
    ) -> CGRect {
        return boundingRect(
            with: .init(width: width, height: height),
            options: .usesLineFragmentOrigin, context: nil
        )
    }
}
