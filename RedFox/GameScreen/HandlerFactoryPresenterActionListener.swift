//
//  GameView.swift
//  RedFox
//
//  Created by Илья Волощик on 14.10.25.
//

import SwiftUI

struct 

ParserUpdaterContextDelegateAdapter: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var gameViewModel = ObserverContextGeneratorValidator()
    @State private var sceneID = UUID()
    @State private var showWinScreen = false
    var enemyName: String
    
    var body: some View {
        GeometryReader { geo in
            let width = geo.size.width
            let height = geo.size.height
            
            ZStack {
                Image("secondBG")
                    .resizable()
                    .ignoresSafeArea()
                
                ConverterValidatorModel(id: sceneID, enemyName: enemyName, viewModel: gameViewModel)
                    .ignoresSafeArea()
                
                HStack {
                    VStack(alignment: .leading) {
                        Button {
                            BuilderCacheClient.shared.playSoundEffect(named: OperationActionView().klick)
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            Image("back_button")
                                .resizable()
                                .frame(width: width*0.075, height: height*0.15)
                        }
                        
                        Spacer()
                        
                        PresenterHelperGeneratorObserverPresenter()
                            .frame(width: width*0.15, height: height*0.15)
                    }
                    
                    Spacer()
                }
                
                if gameViewModel.showWinScreen {
                    ZStack {
                        Color.black.opacity(0.5)
                            .ignoresSafeArea()
                        
                        VStack {
                            Image("winBoard")
                                .resizable()
                                .frame(width: width, height: height*0.8)
                            HStack {
                                Button {
                                    presentationMode.wrappedValue.dismiss()
                                } label: {
                                    Image("menu_button")
                                        .resizable()
                                        .scaledToFit()
                                }
                                
                                Button {
                                    sceneID = UUID()
                                    gameViewModel.showWinScreen = false
                                } label: {
                                    Image("restart_button")
                                        .resizable()
                                        .scaledToFit()
                                }
                            }
                            .frame(width: width*0.4, height: height*0.15)
                            .offset(y: -height*0.15)
                        }
                    }
                }
                
                if gameViewModel.showLoseScreen {
                    ZStack {
                        Color.black.opacity(0.5)
                            .ignoresSafeArea()
                        
                        VStack {
                            Image("loseBoard")
                                .resizable()
                                .frame(width: width*0.4, height: height*0.7)
                            HStack {
                                Button {
                                    presentationMode.wrappedValue.dismiss()
                                } label: {
                                    Image("menu_button")
                                        .resizable()
                                        .scaledToFit()
                                }
                                
                                Button {
                                    sceneID = UUID()
                                    gameViewModel.showLoseScreen = false
                                } label: {
                                    Image("restart_button")
                                        .resizable()
                                        .scaledToFit()
                                }
                            }
                            .frame(width: width*0.4, height: height*0.15)
                        }
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}
