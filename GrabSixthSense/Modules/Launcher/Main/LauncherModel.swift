//
//  LauncherEntity.swift
//  GrabClone
//
//  Created by Ardyan Atmojo on 23/07/24.
//

import Foundation

struct Launcher {
    
    struct Home {
        
        struct MenuResponse: Decodable {
            var menu: Content?
            
            struct Content: Decodable {
                var listMenu: [Payload?]?
            }
            
            struct Payload: Decodable {
                var icon: String?
                var name: String?
            }
        }
        
        
        struct PaymentResponse: Decodable {
            var payment: Content?
            
            struct Content: Decodable {
                var listPayment: [Payload?]?
            }
            
            struct Payload: Decodable {
                var caption: String?
                var content: String?
                var icon: String?
            }
        }
        
        struct PromoResponse: Decodable {
            var promo: Content?
            
            struct Content: Decodable {
                var title: String?
                var listPromo: [Payload?]?
            }
            
            struct Payload: Decodable {
                var image: String?
                var title: String?
                var validUntil: String?
            }
        }
    }
}
