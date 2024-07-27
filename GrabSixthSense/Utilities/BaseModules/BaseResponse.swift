//
//  BaseResponse.swift
//  GrabClone
//
//  Created by Ardyan Atmojo on 15/07/24.
//

import Foundation

struct BaseResponse<T: Decodable>: Decodable {
    var data: T?
    var message: String?
    var code: Int?
}
