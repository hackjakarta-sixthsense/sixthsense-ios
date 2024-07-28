//
//  SplashScreenViewModel.swift
//  GrabSixthSense
//
//  Created by Ardyan Atmojo on 27/07/24.
//

import UIKit

class SplashScreenViewModel: ViewModel {
    
    var coordinator: MainCoordinator?
    weak var view: SplashScreenViewController?
    
    override init() {
        super.init()
        
        $apiState.sink { [weak self] state in
            self?.view?.assignState(with: state)
        }.store(in: &cancleableBag)
    }
    
    func fetch() {
        apiState = .loading
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            self?.apiState = .success
        }
    }
    
    func navigateToHome() {
        coordinator?.navigateToHome()
//        coordinator?.navigateToMaps(destination: "Bundaran HI")
        coordinator?.navigateToMaps(destination: "Grand%20Indonesia")
    }
}
