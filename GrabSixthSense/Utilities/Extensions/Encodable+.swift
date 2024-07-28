//
//  Encodable+.swift
//  GrabSixthSense
//
//  Created by Ardyan Atmojo on 28/07/24.
//

import Foundation

extension Encodable {
    
    func asDictionary() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(
            with: data, options: .allowFragments) as? [String: Any] else {
            throw NSError()
        }
        
        return dictionary
    }
}
