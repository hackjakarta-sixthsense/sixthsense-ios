//
//  Endpoints.swift
//  GrabSixthSense
//
//  Created by Ardyan Atmojo on 27/07/24.
//

import Foundation

enum Endpoints: String {
    
    case homeListMenu = "/list/menu"
    case homeListPayment = "/list/payment"
    case homeListPromo = "/list/promo"
    
    func url() -> String {
        let baseURL = Bundle.main.object(forInfoDictionaryKey: Keys.baseURL.rawValue)
            as! String
        return baseURL + self.rawValue
    }
    
    static func gMapsURL() -> String {
        let baseURL = Bundle.main.object(forInfoDictionaryKey: Keys.gMapsURL.rawValue)
            as! String
        return baseURL
    }
}
