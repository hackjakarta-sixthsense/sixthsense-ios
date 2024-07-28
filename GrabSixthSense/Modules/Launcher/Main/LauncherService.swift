//
//  LauncherInteractor.swift
//  GrabClone
//
//  Created by Ardyan Atmojo on 23/07/24.
//

import Foundation

struct LauncherService {
    
    static func fetchMenu(callback: @escaping (BaseResponse<Launcher.Home.MenuResponse>?) -> ()) {
        ApiRequest.shared.request(Endpoints.homeListMenu.url(), method: .get) {
            switch $0.result {
            case .success(let data):
                if let json = try? JSONDecoder().decode(
                    BaseResponse<Launcher.Home.MenuResponse>.self, from: data!) {
                    callback(json)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    static func fetchPayment(callback: @escaping (BaseResponse<Launcher.Home.PaymentResponse>?) -> ()) {
        ApiRequest.shared.request(Endpoints.homeListPayment.url(), method: .get) {
            switch $0.result {
            case .success(let data):
                if let json = try? JSONDecoder().decode(
                    BaseResponse<Launcher.Home.PaymentResponse>.self, from: data!) {
                    callback(json)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    static func fetchPromo(callback: @escaping (BaseResponse<Launcher.Home.PromoResponse>?) -> ()) {
        ApiRequest.shared.request(Endpoints.homeListPromo.url(), method: .get) {
            switch $0.result {
            case .success(let data):
                if let json = try? JSONDecoder().decode(
                    BaseResponse<Launcher.Home.PromoResponse>.self, from: data!) {
                    callback(json)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
