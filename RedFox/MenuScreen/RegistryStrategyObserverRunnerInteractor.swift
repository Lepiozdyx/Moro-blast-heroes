//
//  MenuView.swift
//  RedFox
//
//  Created by Илья Волощик on 13.10.25.
//


import SwiftUI

struct 

ParserCoordinatorDelegateResolver: View {
    @State private var showSubMenu = false
    var body: some View {
        GeometryReader { geo in
            let width = geo.size.width
            let height = geo.size.height
            
            ZStack {
                Image("menu_Background")
                    .resizable()
                    .ignoresSafeArea()
                
                VStack(spacing: height*0.05) {
                    
//                    Image("icon")
//                        .resizable()
//                        .frame(width: width*0.5, height: width*0.5)
                    
                    Button {
                        showSubMenu = true
                    } label: {
                        Image("play_button")
                            .resizable()
                            .frame(width: width*0.5, height: height*0.125)
                    }
                    
                    ContextListenerObserverHelper(imageName: "shop_button", destination: BridgeMapperAdapterProcessorReader())
                        .frame(width: width*0.4, height: height*0.125)
                    
                    ContextListenerObserverHelper(imageName: "settings_button", destination: MapperCheckerAdapterStrategyProvider())
                        .frame(width: width*0.3, height: height*0.125)
                    
                    HelperContextWriterManager(imageName: "info_button", destination: ClientSessionRunnerPresenter())
                        .frame(width: width*0.2, height: height*0.125)
                }
                
                if showSubMenu {
                    ZStack {
                        Color.black.opacity(0.5)
                            .ignoresSafeArea()
                            .onTapGesture {
                                showSubMenu = false
                            }
                        
                        Image("settings_border")
                            .resizable()
                            .frame(width: width*0.8, height: height*0.3)
                        
                        VStack(spacing: height*0.03) {
                            Image("play_title")
                                .resizable()
                                .frame(width: width*0.2, height: height*0.05)
                            
                            ContextListenerObserverHelper(imageName: "playWithAI_Button", destination: TaskRegistryServiceSaverProcessor())
                                .frame(width: width*0.5, height: height*0.075)
                            
                            ContextListenerObserverHelper(imageName: "findTheEnemy_Button", destination: RegistryLoaderPresenterHelper())
                                .frame(width: width*0.5, height: height*0.075)
                        }
                    }
                }
            }
            .frame(width: width)
            .frame(height: height)
        }
        .navigationBarBackButtonHidden(true)
        .onAppear{ EngineMapperEngineStrategyValidator.orientaionMask = .portrait}
    }
}

struct 

SessionStoreAdapter: PreviewProvider {
    static var previews: some View {
        ParserCoordinatorDelegateResolver()
    }
}
