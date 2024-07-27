//
//  TransportService.swift
//  GrabSixthSense
//
//  Created by Muhammad Ziddan on 27/07/24.
//

import Foundation

struct TransportService {
    
    static func fetchMap(originPoint: String, destinationPoint: String, callback: @escaping ([String: AnyObject]?) -> ()) {
        let urlString = "https://maps.googleapis.com/maps/api/directions/json?destination=\(destinationPoint)&origin=\(originPoint)&region=id&mode=driving&key=AIzaSyAF33xAdH7MRJFIk_NKaOELizcR3bL0--s"
        
        ApiRequest.shared.request(urlString, method: .post) { response in
            switch response.result {
            case .success:
                if let data = response.data {
                    do {
                        let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as! [String: AnyObject]
                        callback(jsonObject)
                    } catch {
                        print("error parse data")
                    }
                } else {
                    print("error get data")
                }
                
            case .failure:
                print("error fetch")
            }
        }
    }
    
    static func fetchSuggestionDestination(destination: String, callback: @escaping (DestinationSuggestionResponse?) -> ()) {
        let urlString = "https://maps.googleapis.com/maps/api/place/textsearch/json?query=\(destination)&key=AIzaSyAF33xAdH7MRJFIk_NKaOELizcR3bL0--s"
        
        ApiRequest.shared.request(urlString, method: .post) { response in
            switch response.result {
            case .success:
                if let data = response.data {
                    do {
                        let decodeObject = try JSONDecoder().decode(DestinationSuggestionResponse.self, from: data)
                        print("suggestion fetch: \(decodeObject)")
                        callback(decodeObject)
                    } catch {
                        print("error parse data")
                    }
                } else {
                    print("error get data")
                }
            case .failure:
                print("error fetch")
            }
        }
    }
    
}
