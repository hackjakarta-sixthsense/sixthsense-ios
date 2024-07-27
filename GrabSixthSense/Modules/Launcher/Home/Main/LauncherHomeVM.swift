//
//  LauncherHomeVM.swift
//  GrabSixthSense
//
//  Created by Ardyan Atmojo on 27/07/24.
//

import UIKit

class LauncherHomeVM: ViewModel {
    
    var coordinator: MainCoordinator?
    weak var view: LauncherHomeVC?
    
    var menuResponse: Launcher.Home.MenuResponse?
    var paymentResponse: Launcher.Home.PaymentResponse?
    var promoResponse: Launcher.Home.PromoResponse?
    let bgHeight: CGFloat = .apply(currentDevice: .statusBarHeight) +
        .apply(insets: .medium) + (.apply(contentSize: .rectHeight) / 2)
    
    override init() {
        super.init()
        
        $apiState.sink { [weak self] state in
            self?.view?.assignState(with: state)
        }.store(in: &cancleableBag)
    }
    
    func fetch() {
        menuResponse = nil
        paymentResponse = nil
        promoResponse = nil
        apiState = .loading
        
        let dispathGroup = DispatchGroup()
        
        dispathGroup.enter()
        LauncherService.fetchMenu { [weak self] response in
            self?.menuResponse = response?.data
            dispathGroup.leave()
        }
        
        dispathGroup.enter()
        LauncherService.fetchPayment { [weak self] response in
            self?.paymentResponse = response?.data
            dispathGroup.leave()
        }
        
        dispathGroup.enter()
        LauncherService.fetchPromo { [weak self] response in
            self?.promoResponse = response?.data
            dispathGroup.leave()
        }
        
        dispathGroup.notify(queue: .main) { [weak self] in
            self?.apiState = .success
        }
    }
    
    func presentModalVoice() {
        coordinator?.presentSpeechModal()
    }
}
