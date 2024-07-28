//
//  SearchSpeechModel.swift
//  GrabSixthSense
//
//  Created by Muhammad Ziddan on 28/07/24.
//

import Foundation

struct RequestSearch: Encodable {
    var prompt: String?
}

struct SearchResponse: Decodable {
    var value: String?
    var category: String?
    var valueRegex: String?
    var categoryRegex: String?
    var optionRegex: String?
    var payload: TenantPayload?
}

struct TenantPayload: Decodable {
    var tenantId: Int?
    var tenantName: String?
    var tag: [String]?
    var ratingValue: Int?
    var ratingCount: Int?
    var tenantOutlets: Int?
    var estimateDeliveryTime: String?
}
