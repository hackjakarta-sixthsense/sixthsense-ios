//
//  ApiRequest.swift
//  GrabClone
//
//  Created by Ardyan Atmojo on 12/07/24.
//

import Foundation
import Alamofire

struct ApiRequest {
    
    static let shared = ApiRequest()
    
    func request(
        _ endpoint: String, method: HTTPMethod,
        parameters: Parameters? = nil, headers: HTTPHeaders? = nil,
        completion: @escaping (_ response: DataResponse<Optional<Data>, AFError>) -> Void) {
            AF.request(endpoint, method: method, parameters: parameters, headers: headers)
                .validate().response { response in
                    completion(response)
            }
    }
}

enum ApiState {
    case idle
    case loading
    case success
    case failure
}
