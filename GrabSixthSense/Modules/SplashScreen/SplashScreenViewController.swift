//
//  SplashScreenViewController.swift
//  GrabSixthSense
//
//  Created by Ardyan Atmojo on 27/07/24.
//

import UIKit
import CoreLocation

class SplashScreenViewController: ViewController {
    
    private let viewModel: SplashScreenViewModel
    
    private let logoIV = UIImageView()
    private let illustrationIV = UIImageView()
    private let locationManager = CLLocationManager()
    
    init(viewModel: SplashScreenViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    internal override func viewDidLoad() {
        super.viewDidLoad()
        setupLocation()
        
        view.backgroundColor = .accent
        
        [logoIV, illustrationIV].forEach { [weak self] view in
            self?.view.addSubview(view)
        }
        
        logoIV.image = .apply(assets: .iconLogo)?
            .withRenderingMode(.alwaysTemplate)
        logoIV.tintColor = .white
        logoIV.contentMode = .scaleAspectFit
        logoIV.constraints(
            centerX: (view.centerXAnchor, 0),
            centerY: (view.centerYAnchor, -CGFloat.apply(insets: .xLarge)),
            width: 128, height: 47)
        
        illustrationIV.image = .apply(assets: .imgSplashIllustration)
        illustrationIV.contentMode = .scaleAspectFill
        illustrationIV.constraints(
            leading: view.leadingAnchor, bottom: view.bottomAnchor,
            trailing: view.trailingAnchor)
        
        viewModel.fetch()
    }
}

extension SplashScreenViewController {
    
    func assignState(with state: ApiState) {
        switch state {
        case .success: viewModel.navigateToHome()
        default: break
        }
    }
}

extension SplashScreenViewController: CLLocationManagerDelegate {
    
    private func setupLocation() {
        locationManager.requestWhenInUseAuthorization()
    }
    
}
