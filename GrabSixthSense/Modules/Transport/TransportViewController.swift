//
//  TransportViewController.swift
//  GrabSixthSense
//
//  Created by Ardyan Atmojo on 27/07/24.
//

import UIKit
import GoogleMaps

class TransportViewController: ViewController {
    
    private var viewModel: TransportViewModel
    
    private let locationManager = CLLocationManager()
    private var currentLocationDegrees: [CLLocationDegrees]?
    
    private let backgroundView = UIView()
    private let mapView = GMSMapView()
    private let bottomView = UIView()
    private let backButton = CircleFloatingButton()
    
    private let bookButton = OvalButton()
    private var bookButtonWidthAnchor: NSLayoutConstraint?
    private let calendarButton = CircleFloatingButton()
    
    init(viewModel: TransportViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    internal override func viewDidLoad() {
        super.viewDidLoad()
        setupBackgroundView()
    }
    
    internal override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupLocationManager()
    }
    
    private func setupBackgroundView() {
        view.addSubview(backgroundView)
        backgroundView.backgroundColor = .white
        backgroundView.constraints(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
        backgroundView.addSubviews([bottomView, mapView, backButton])
        setupBackgroundSubview()
    }
    
    private func setupBackgroundSubview() {
        setupBottomView()
        setupMapsView()
        setupBackButton()
    }
    
    private func setupBottomView() {
        bottomView.constraints(leading: backgroundView.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: backgroundView.trailingAnchor, height: .apply(contentSize: .actionBottomViewHeight))
        bottomView.addSubviews([calendarButton, bookButton])
        setupBottomSubview()
    }
    
    private func setupMapsView() {
        mapView.constraints(top: backgroundView.topAnchor, leading: backgroundView.leadingAnchor, bottom: bottomView.topAnchor, trailing: backgroundView.trailingAnchor)
        mapView.camera = GMSCameraPosition.camera(withLatitude: -6.194528, longitude: 106.8232249, zoom: 15.0)
    }
    
    private func setupBackButton() {
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.constraints(top: backgroundView.safeAreaLayoutGuide.topAnchor, leading: backgroundView.leadingAnchor, padding: .init(top: 0, left: .apply(insets: .medium), bottom: 0, right: 0), width: .apply(iconSize: .large), height: .apply(iconSize: .large))
        backButton.backgroundColor = .white
        backButton.tintColor = .black
        backButton.setImage(UIImage(systemName: "arrow.backward"), for: .normal)
    }
    
    private func setupBottomSubview() {
        setupCalendarButton()
        setupBookButton()
    }
    
    private func setupBookButton() {
        bookButtonWidthAnchor = bookButton.widthAnchor.constraint(greaterThanOrEqualToConstant: .apply(contentSize: .buttonHeight))
        bookButton.translatesAutoresizingMaskIntoConstraints = false
        bookButton.constraints(
            leading: calendarButton.trailingAnchor,
            bottom: view.safeAreaLayoutGuide.bottomAnchor,
            trailing: bottomView.trailingAnchor,
            padding: .init(top: 0, left: .apply(insets: .xSmall), bottom: 0, right: .apply(insets: .medium)),
            height: .apply(contentSize: .tabbarHeight),
            customAnchors: [bookButtonWidthAnchor!])
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.apply(.medium, size: .body),
            .foregroundColor: UIColor.white
        ]
        let attributedTitle = NSAttributedString(string: "Book GrabCar", attributes: attributes)
        bookButton.setAttributedTitle(attributedTitle, for: .normal)
        bookButton.tintColor = .white
        bookButton.backgroundColor = .systemGreen
    }
    
    private func setupCalendarButton() {
        calendarButton.translatesAutoresizingMaskIntoConstraints = false
        calendarButton.constraints(leading: bottomView.leadingAnchor, centerY: (bookButton.centerYAnchor, 0), padding: .init(top: 0, left: .apply(insets: .medium), bottom: 0, right: 0), width: .apply(iconSize: .xLarge), height: .apply(iconSize: .xLarge))
        calendarButton.tintColor = .darkGray
        calendarButton.backgroundColor = .systemGray2
        calendarButton.setImage(UIImage(systemName: "calendar"), for: .normal)
    }
    
}

extension TransportViewController {
    
    func assignState(state: ApiState) {
        switch state {
        case .loading:
            print("fetch state")
        case .success:
            updateMaps()
        default: break
        }
    }
    
}

extension TransportViewController {
    
    func updateMaps() {
        addMapMarker(originPoint: viewModel.originDegree ?? [CLLocationDegrees](), destinationPoint: viewModel.destinationDegree ?? [CLLocationDegrees]())
        mapsBoundSetter()
        updateMapsView(mapsPath: viewModel.mapsBounds ?? GMSPath())
    }
    
    private func addMapMarker(originPoint: [CLLocationDegrees], destinationPoint: [CLLocationDegrees]) {
        let sourceMarker = GMSMarker()
        sourceMarker.position = CLLocationCoordinate2D(latitude: originPoint[0], longitude: originPoint[1])
        sourceMarker.title = "Source"
        sourceMarker.map = mapView
        
        let destinationMarker = GMSMarker()
        destinationMarker.position = CLLocationCoordinate2D(latitude: destinationPoint[0], longitude: destinationPoint[1])
        destinationMarker.title = "Destination"
        destinationMarker.map = mapView
    }
    
    private func mapsBoundSetter() {
        let bounds = GMSCoordinateBounds(path: viewModel.mapsBounds ?? GMSPath())
        mapView.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 70.0))
    }
    
    func updateMapsView(mapsPath pathArray: GMSPath) {
        let currentPath = GMSMutablePath()
        let polyline = GMSPolyline(path: currentPath)
        polyline.strokeWidth = 8
        polyline.strokeColor = .systemGreen
        polyline.map = mapView
        var index = 0
        
        Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { timer in
            if index < pathArray.count() {
                currentPath.add(pathArray.coordinate(at: UInt(index)))
                polyline.path = currentPath
                index += 1
            } else {
                timer.invalidate()
            }
        }
    }
    
}

extension TransportViewController: CLLocationManagerDelegate {
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let currentLocation = location.coordinate
            currentLocationDegrees = [currentLocation.latitude, currentLocation.longitude]
            let point = String(currentLocation.latitude) + "," + String(currentLocation.longitude)
            print("point: \(point)")
            viewModel.fetch(originPoint: point, destinationPoint: viewModel.destination ?? "")
            
            locationManager.stopUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to locate device: \(error)")
    }
    
}
