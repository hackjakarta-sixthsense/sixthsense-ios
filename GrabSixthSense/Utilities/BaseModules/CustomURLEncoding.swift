//
//  CustomURLEncoding.swift
//  GrabSixthSense
//
//  Created by Ardyan Atmojo on 28/07/24.
//

import Foundation
import Alamofire

struct CustomURLEncoding: ParameterEncoding {
    let allowedCharacters: CharacterSet

    func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var request = try urlRequest.asURLRequest()
        
        guard let parameters = parameters else { return request }
        
        if var urlComponents = URLComponents(url: request.url!, resolvingAgainstBaseURL: false), !parameters.isEmpty {
            let percentEncodedQuery = (urlComponents.percentEncodedQuery.map { $0 + "&" } ?? "") + query(parameters)
            urlComponents.percentEncodedQuery = percentEncodedQuery
            
            request.url = urlComponents.url
        }
        
        return request
    }
    
    private func query(_ parameters: [String: Any]) -> String {
        var components: [(String, String)] = []
        
        for key in parameters.keys.sorted(by: <) {
            let value = parameters[key]!
            components += queryComponents(fromKey: key, value: value)
        }
        
        return components.map { "\($0)=\($1)" }.joined(separator: "&")
    }

    private func queryComponents(fromKey key: String, value: Any) -> [(String, String)] {
        var components: [(String, String)] = []

        if let dictionary = value as? [String: Any] {
            for (nestedKey, value) in dictionary {
                components += queryComponents(fromKey: "\(key)[\(nestedKey)]", value: value)
            }
        } else if let array = value as? [Any] {
            for value in array {
                components += queryComponents(fromKey: "\(key)[]", value: value)
            }
        } else {
            components.append((escape(key), escape("\(value)")))
        }

        return components
    }

    private func escape(_ string: String) -> String {
        let allowedCharacterSet = allowedCharacters
        return string.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) ?? string
    }
}
