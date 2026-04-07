//
//  GameViewModel.swift
//  RedFox
//
//  Created by Илья Волощик on 14.10.25.
//


import SwiftUI
import Combine

class 

ObserverContextGeneratorValidator: ObservableObject {
    
    @Published var showWinScreen = false
    @Published var showLoseScreen = false

    func showWinView() {
        showWinScreen = true
        PresenterConnectorPresenterClientProcessor.shared.addCoins(100)
    }
    
    func showLoseView() {
        showLoseScreen = true
    }
}
