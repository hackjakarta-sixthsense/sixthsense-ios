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
    
    let bgHeight: CGFloat = .apply(currentDevice: .statusBarHeight) + .apply(insets: .medium) + (.apply(contentSize: .rectHeight) / 2)
}
