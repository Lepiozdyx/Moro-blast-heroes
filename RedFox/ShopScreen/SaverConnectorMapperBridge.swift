//
//  ShopView.swift
//  RedFox
//
//  Created by Илья Волощик on 13.10.25.
//

import SwiftUI

struct 

BridgeMapperAdapterProcessorReader: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var manager = ActionManagerSession.shared

    var body: some View {
        GeometryReader { geo in
            let width = geo.size.width
            let height = geo.size.height
            
            ZStack {
                Image("secondBG")
                    .resizable()
                    .ignoresSafeArea()
                
                VStack {
                    HStack(alignment: .center, spacing: width*0.125) {
                        Button {
                            BuilderCacheClient.shared.playSoundEffect(named: OperationActionView().klick)
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            Image("back_button")
                                .resizable()
                                .frame(width: width*0.2, height: height*0.1)
                        }
                        .padding(.leading)
                        
                        Image("shop_title")
                            .resizable()
                            .frame(width: width*0.3, height: height*0.06)
                        
                        Spacer()
                    }
                    .frame(height: height*0.1)
                    .padding(.top)
                    
                    PresenterHelperGeneratorObserverPresenter()
                        .frame(width: width*0.3, height: height*0.1)
                    
                    VStack(spacing: height*0.1) {
                        HStack(spacing: width*0.075) {
                            PresenterRunnerPolicyExecutor(shopItem: manager.shopItems[0])
                            PresenterRunnerPolicyExecutor(shopItem: manager.shopItems[1])
                        }
                        .frame(width: width*0.8, height: height*0.2)
                        
                        HStack(spacing: width*0.075) {
                            PresenterRunnerPolicyExecutor(shopItem: manager.shopItems[2])
                            PresenterRunnerPolicyExecutor(shopItem: manager.shopItems[3])
                        }
                        .frame(width: width*0.8, height: height*0.2)
                    }
                
                    Spacer()
                }
                
                VStack() {
                    
                    Spacer()
                }
                
            }
            .frame(width: width)
            .frame(height: height)
        }
        .navigationBarBackButtonHidden(true)
        .onAppear{
            manager.updateStatus()
        }
    }
}
