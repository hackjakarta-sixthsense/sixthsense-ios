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
            var payload: [Payload?]?
            
            struct Payload: Decodable {
                var icon: String?
                var name: String?
            }
        }
        
        
        struct PaymentResponse: Decodable {
            var payload: [Payload?]?
            
            struct Payload: Decodable {
                var caption: String?
                var title: String?
                var icon: String?
            }
        }
        
        struct PromoResponse: Decodable {
            var title: String?
            var payload: [Payload?]?
            
            struct Payload: Decodable {
                var image: String?
                var title: String?
                var validUntil: String?
            }
        }
    }
}
