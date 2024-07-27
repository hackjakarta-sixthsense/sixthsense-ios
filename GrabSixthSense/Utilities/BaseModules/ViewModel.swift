//
//  ViewModel.swift
//  GrabSixthSense
//
//  Created by Ardyan Atmojo on 27/07/24.
//

import Foundation
import Combine

class ViewModel {
    @Published var apiState: ApiState = .idle
    var cancleableBag = Set<AnyCancellable>()
}
