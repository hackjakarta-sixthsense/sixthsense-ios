//
//  Coordinator.swift
//  GrabSixthSense
//
//  Created by Ardyan Atmojo on 27/07/24.
//

import UIKit

protocol Coordinator {
    var navigation: UINavigationController { get set }
    var children: [Coordinator] { get set }
}
