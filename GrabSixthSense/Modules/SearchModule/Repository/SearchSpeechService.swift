//
//  SearchSpeechService.swift
//  GrabSixthSense
//
//  Created by Muhammad Ziddan on 28/07/24.
//

import Foundation


struct SearchSpeechService {
    
    static func fetchSearchResult(requestPrompt: String, callback: @escaping (SearchResponse?) -> ()) {
        let urlString = "http://34.128.71.244:8080/search"
        let url = URL(string: urlString)
        
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let param = RequestSearch(prompt: requestPrompt)
            do {
                let jsonData = try JSONEncoder().encode(param)
                request.httpBody = jsonData
            } catch {
                print("Error encoding JSON: \(error)")
                return
            }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("error fetch: \(String(describing: error))")
                return
            }
            
            do {
                print("called fetch")
                let decode = try JSONDecoder().decode(SearchResponse.self, from: data)
                print("response data: \(decode)")
                callback(decode)
            } catch {
                print("error decode: \(error)")
            }
        }.resume()
    }
    
}
