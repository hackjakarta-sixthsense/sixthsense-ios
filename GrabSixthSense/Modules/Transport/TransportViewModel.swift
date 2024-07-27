//
//  TransportViewModel.swift
//  GrabSixthSense
//
//  Created by Ardyan Atmojo on 27/07/24.
//

import UIKit
import GoogleMaps

class TransportViewModel: ViewModel {
    
    var coordinator: MainCoordinator?
    weak var view: TransportViewController?
    
    var destination: String?
    var mapsBounds: GMSPath?
    var originDegree: [CLLocationDegrees]?
    var destinationDegree: [CLLocationDegrees]?
    
    override init() {
        super.init()
        
        $apiState.sink { [weak self] state in
            guard let self = self else { return }
            self.view?.assignState(state: state)
        }.store(in: &cancleableBag)
    }
    
    func fetch(originPoint: String, destinationPoint: String) {
        mapsBounds = nil
        apiState = .loading
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        TransportService.fetchMap(originPoint: originPoint, destinationPoint: destinationPoint) { [weak self] mapResponse in
            guard let self = self else { return }
            guard let mapResponse = mapResponse else { return }
            let routes = mapResponse["routes"] as! NSArray
            self.createPolyline(with: routes)
            self.getCoordinate(with: routes)
            dispatchGroup.leave()
        }
        
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
    
    func getCoordinate(with routes: NSArray) {
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
    
}
