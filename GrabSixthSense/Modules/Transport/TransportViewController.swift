//
//  TransportViewController.swift
//  GrabSixthSense
//
//  Created by Ardyan Atmojo on 27/07/24.
//

import Foundation

class TransportViewController: ViewController {
    private var viewModel: TransportViewModel
    
    init(viewModel: TransportViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func assignState(state: ApiState) {
        
    }
    
}
