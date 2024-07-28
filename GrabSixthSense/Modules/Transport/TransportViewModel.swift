//
//  TransportViewModel.swift
//  GrabSixthSense
//
//  Created by Ardyan Atmojo on 27/07/24.
//

import UIKit
import GoogleMaps
import Combine

class TransportViewModel: ViewModel {
    
    var coordinator: MainCoordinator?
    weak var view: TransportViewController?
    
    var destination: String?
    var mapsBounds: GMSPath?
    var originDegree: [CLLocationDegrees]?
    var destinationDegree: [CLLocationDegrees]?
    
    var tripFare: String?
    var tripDuration: Int?
    
    var destinationSuggestionList: DestinationSuggestionResponse?
    var publishIsDestinationExist = true
    
    override init() {
        super.init()
        
        $apiState.sink { [weak self] state in
            guard let self = self else { return }
            self.view?.assignState(state: state)
        }.store(in: &cancleableBag)
    }
    
    func fetch(originPoint: String, destinationPoint: String) {
        mapsBounds = nil
        publishIsDestinationExist = true
        apiState = .loading
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        TransportService.fetchMap(originPoint: originPoint, destinationPoint: destinationPoint) { [weak self] mapResponse in
            guard let self = self, let mapResponse = mapResponse else { return }
            let status = mapResponse["status"] as! String
            if status == "OK" {
                print("it is ok")
                let routes = mapResponse["routes"] as! NSArray
                self.createPolyline(with: routes)
                self.getCoordinate(with: routes)
                self.getDistance(with: routes)
            } else {
                print("not ok")
                publishIsDestinationExist = false
            }
            
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            if publishIsDestinationExist {
                apiState = .success
            } else {
                apiState = .failure
            }
        }
    }
    
    func fetchDestinationSuggestion() {
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        TransportService.fetchSuggestionDestination(destination: destination!) { [weak self] suggestionList in
            guard let suggestionList = suggestionList, let self = self else { return }
            self.destinationSuggestionList = suggestionList
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        
        dispatchGroup.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            apiState = .success
        }
    }
    
    private func createPolyline(with routes: NSArray) {
        let overviewPolyline = (routes[0] as! NSDictionary).value(forKey: "overview_polyline") as! NSDictionary
        let points = overviewPolyline.object(forKey: "points")
        mapsBounds = GMSPath.init(fromEncodedPath: points! as! String) ?? GMSPath()
    }
    
    private func getCoordinate(with routes: NSArray) {
        var pathArray = [GMSPath]()
        let legs: NSArray = (routes[0] as! NSDictionary).value(forKey: "legs") as! NSArray
        let steps: NSArray = (legs[0] as! NSDictionary).value(forKey: "steps") as! NSArray
        
        let startLocation: NSDictionary = (legs[0] as! NSDictionary).value(forKey: "start_location") as! NSDictionary
        let endLocation: NSDictionary = (legs[0] as! NSDictionary).value(forKey: "end_location") as! NSDictionary
        
        let originLatitudeCoordinate: CLLocationDegrees = startLocation.object(forKey: "lat") as! CLLocationDegrees
        let originLongitudeCoordinate: CLLocationDegrees = startLocation.object(forKey: "lng") as! CLLocationDegrees
        
        let destinationLatitudeCoordinate: CLLocationDegrees = endLocation.object(forKey: "lat") as! CLLocationDegrees
        let destinationLongitudeCoordinate: CLLocationDegrees = endLocation.object(forKey: "lng") as! CLLocationDegrees
        
        originDegree = [originLatitudeCoordinate, originLongitudeCoordinate]
        destinationDegree = [destinationLatitudeCoordinate, destinationLongitudeCoordinate]
    }
    
    func getDistance(with routes: NSArray) {
        let legs: NSArray = (routes[0] as! NSDictionary).value(forKey: "legs") as! NSArray
        let distanceData = (legs[0] as! NSDictionary).value(forKey: "distance") as! NSDictionary
        let durationData = (legs[0] as! NSDictionary).value(forKey: "duration") as! NSDictionary
        let distanceInMeter = distanceData.object(forKey: "value") as! Int
        let durationInSeconds = durationData.object(forKey: "value") as! Int
        
        tripFare = fareCalculation(distance: distanceInMeter)
        tripDuration = durationInSeconds
    }
    
    func fareCalculation(distance: Int) -> String {
        let baseFare = 10000.0 // Base fare in Rupiah
        let farePerKm = 5000.0 // Fare per kilometer in Rupiah
            
        let distanceInKm = Double(distance) / 1000.0
        let fare = baseFare + (farePerKm * distanceInKm)
            
        return formatToRupiah(fare)
    }
    
    func formatToRupiah(_ amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "id_ID")
        formatter.currencySymbol = "Rp"
        formatter.maximumFractionDigits = 0
        
        if let formattedAmount = formatter.string(from: NSNumber(value: amount)) {
            return formattedAmount
        } else {
            return "Rp \(amount)"
        }
    }
    
}
