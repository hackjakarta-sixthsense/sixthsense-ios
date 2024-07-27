//
//  LauncherInteractor.swift
//  GrabClone
//
//  Created by Ardyan Atmojo on 23/07/24.
//

import Foundation

struct LauncherService {
    
    static func fetchMenu(callback: @escaping (BaseResponse<Launcher.Home.MenuResponse>?) -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            callback(.init(data: .init(payload: [
                .init(
                    icon: Assets.iconHomeFood.rawValue,
                    name: "Food"
                ),
                .init(
                    icon: Assets.iconHomeMart.rawValue,
                    name: "Mart"
                ),
                .init(
                    icon: Assets.iconHomeExpress.rawValue,
                    name: "Express"
                ),
                .init(
                    icon: Assets.iconHomeTransport.rawValue,
                    name: "Transport"
                ),
                .init(
                    icon: Assets.iconHomeMall.rawValue,
                    name: "Mall"
                ),
                .init(
                    icon: Assets.iconHomeOffers.rawValue,
                    name: "Offers"
                ),
                .init(
                    icon: Assets.iconHomeGift.rawValue,
                    name: "Gift Cards"
                ),
                .init(
                    icon: Assets.iconHomeMore.rawValue,
                    name: "More"
                ),
            ])))
        }
    }
    
    static func fetchPayment(callback: @escaping (BaseResponse<Launcher.Home.PaymentResponse>?) -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            callback(.init(data: .init(payload: [
                .init(caption: "Activate", title: "GrabPay", icon: Assets.iconGrabPay.rawValue),
                .init(caption: "Use Points", title: "758", icon: Assets.iconCrown.rawValue)
            ])))
        }
    }
    
    static func fetchPromo(callback: @escaping (BaseResponse<Launcher.Home.PromoResponse>?) -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            callback(.init(data: .init(
                title: "Celebrate Mid-Autumn Festival",
                payload: [
                    .init(
                        image: Assets.imgHomePromo1.rawValue,
                        title: "Order mooncakes to gift & to enjoy",
                        validUntil: "21 Sep"
                    ),
                    .init(
                        image: Assets.imgHomePromo2.rawValue,
                        title: "Plus an EXTRA $20 OFF on groceries",
                        validUntil: "31 Aug"
                    )
                ]
            )))
        }
    }
}
