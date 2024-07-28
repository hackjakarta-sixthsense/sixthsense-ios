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
        let urlString = "https://maps.googleapis.com/maps/api/place/textsearch/json?query=\(destination)&key=AIzaSyDFJcgKnokCBHtr2jXUhysaej5DdK-tp7w"
        
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
    
    static func fetchDistanceMatrix(origin: String, destination: String, callback: @escaping (Int?) -> Void) {
        let apiKey = "AIzaSyDFJcgKnokCBHtr2jXUhysaej5DdK-tp7w"
        let urlString = "https://maps.googleapis.com/maps/api/distancematrix/json?units=metric&origins=\(origin)&destinations=\(destination)&key=\(apiKey)"
        
        ApiRequest.shared.request(urlString, method: .post) { response in
            switch response.result {
            case .success:
                if let data = response.data {
                    do {
                        let decodeObject = try JSONDecoder().decode(DistanceMatrixResponse.self, from: data)
                        let distance = decodeObject.rows[0].elements[0].distance.value
                        callback(distance)
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
    
    static func cleansingAddress(input: String, callback: @escaping (Int?) -> ()) {
        let urlString = ""
        
        ApiRequest.shared.request(urlString, method: .post) { response in
            switch response.result {
            case .success:
                if let data = response.data {
                    do {
                        let decodeObject = try JSONDecoder().decode(DistanceMatrixResponse.self, from: data)
                        let distance = decodeObject.rows[0].elements[0].distance.value
                        callback(distance)
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
