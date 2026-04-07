//
//  ShopItemView.swift
//  RedFox
//
//  Created by Илья Волощик on 13.10.25.
//


import SwiftUI

struct 

PresenterRunnerPolicyExecutor: View {
    let shopItem: WriterWriterCheckerStore
    
    var body: some View {
        GeometryReader { geo in
            let width = geo.size.width
            let height = geo.size.height
            
            Button {
                BuilderCacheClient.shared.playSoundEffect(named: OperationActionView().klick)
                if shopItem.status == .available {
                    UserDefaults.standard.set(shopItem.itemNumber, forKey: "pickedModel")
                } else if shopItem.status == .readyToBuy {
                    ActionManagerSession.shared.buyItem(number: shopItem.itemNumber)
                }
            } label: {
                ZStack {
                    Image("shopItem_\(shopItem.itemNumber)")
                        .resizable()
                        .scaledToFit()
                    
                    if shopItem.status == .locked || shopItem.status == .readyToBuy {
                        Image("price_button_\(shopItem.price)")
                            .resizable()
                            .frame(width: width*0.8, height: height*0.3)
                            .offset(y: height*0.4)
                    }
                }
                .frame(width: width, height: height)
            }
            .disabled(shopItem.status == .locked)
        }
    }
}
