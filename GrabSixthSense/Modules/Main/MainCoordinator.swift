//
//  MainCoordinator.swift
//  GrabSixthSense
//
//  Created by Ardyan Atmojo on 27/07/24.
//

import UIKit

struct MainCoordinator: Coordinator {
    
    var navigation: UINavigationController
    var children = [Coordinator]()
    
    init(navigation: UINavigationController) {
        self.navigation = navigation
    }
    
    func start() {
        let viewModel = SplashScreenViewModel()
        let view = SplashScreenViewController(viewModel: viewModel)
        viewModel.coordinator = self
        viewModel.view = view
        navigation.pushViewController(view, animated: false)
    }
    
    func navigateToHome() {
        let viewModel = LauncherHomeVM()
        let view = LauncherHomeVC(viewModel: viewModel)
        viewModel.coordinator = self
        viewModel.view = view
        navigation.pushViewController(view, animated: true)
    }
}
