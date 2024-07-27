//
//  SearchSpeechModal.swift
//  GrabSixthSense
//
//  Created by Ardyan Atmojo on 27/07/24.
//

import UIKit

class SearchSpeechModal: ViewController {
    
    private let viewModel: SearchSpeechViewModel
    
    init(viewModel: SearchSpeechViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
