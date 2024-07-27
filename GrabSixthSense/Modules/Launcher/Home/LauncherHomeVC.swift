//
//  LauncherHomeVC.swift
//  GrabSixthSense
//
//  Created by Ardyan Atmojo on 27/07/24.
//

import UIKit

class LauncherHomeVC: ViewController {
    
    private let viewModel: LauncherHomeVM
    
    init(viewModel: LauncherHomeVM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    internal override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .green
    }
}
