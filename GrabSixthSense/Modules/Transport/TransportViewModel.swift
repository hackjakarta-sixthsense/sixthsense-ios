//
//  TransportViewModel.swift
//  GrabSixthSense
//
//  Created by Ardyan Atmojo on 27/07/24.
//

import UIKit

class TransportViewModel: ViewModel {
    
    var mainCoordinator: MainCoordinator?
    weak var view: TransportViewController?
    
    override init() {
        super.init()
        
        $apiState.sink { [weak self] state in
            guard let self = self else { return }
            self.view?.assignState(state: state)
        }.store(in: &cancleableBag)
    }
    
    func fetch() {
        apiState = .loading
    }
    
}
