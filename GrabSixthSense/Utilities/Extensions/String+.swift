//
//  String+.swift
//  GrabClone
//
//  Created by Ardyan Atmojo on 21/07/24.
//

import SwiftUI

extension String {
    
    func convertLongTo(dateFormat: String) -> String? {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [
            .withInternetDateTime, .withFractionalSeconds
        ]
        
        if let selfDate = isoFormatter.date(from: self) {
            let formatter = DateFormatter()
            formatter.dateFormat = dateFormat
            return formatter.string(from: selfDate)
        }
        
        return nil
    }
}

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
