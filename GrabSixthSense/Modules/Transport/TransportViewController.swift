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
        backgroundView.addSubviews([mapView, backButton])
    }
    
}

extension TransportViewController {
    
    func assignState(state: ApiState) {
        
    }
    
}
