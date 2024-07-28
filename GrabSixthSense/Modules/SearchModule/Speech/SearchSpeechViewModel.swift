//
//  SearchSpeechViewModel.swift
//  GrabSixthSense
//
//  Created by Ardyan Atmojo on 27/07/24.
//

import UIKit

class SearchSpeechViewModel: ViewModel {
    
    var coordinator: MainCoordinator?
    weak var view: SearchSpeechModal?
    
    override init() {
        super.init()
        
        $apiState.sink { [weak self] state in
            self?.view?.assignState(with: state)
        }.store(in: &cancleableBag)
    }
    
    
}
