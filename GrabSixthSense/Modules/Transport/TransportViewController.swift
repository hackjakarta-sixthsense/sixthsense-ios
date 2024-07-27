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
    
    private let backgroundView = UIView()
    private let mapView = GMSMapView()
    private let bottomView = UIView()
    private let backButton = CircleFloatingButton()
    
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
    
}

extension TransportViewController {
    
    func assignState(state: ApiState) {
        
    }
    
}
