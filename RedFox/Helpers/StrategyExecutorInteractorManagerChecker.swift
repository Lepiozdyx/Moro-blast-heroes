//
//  CoinManager.swift
//  RedFox
//
//  Created by Илья Волощик on 13.10.25.
//


import Foundation
import Combine

final class 

PresenterConnectorPresenterClientProcessor: ObservableObject {
    static let shared = PresenterConnectorPresenterClientProcessor()
    
    @Published var coins: Int {
        didSet {
            UserDefaults.standard.set(coins, forKey: "userCoins")
        }
    }
    
    private init() {
        coins = UserDefaults.standard.integer(forKey: "userCoins")
    }
    
    func addCoins(_ amount: Int) {
        coins += amount

    }
    
    func spendCoins(_ amount: Int) {
        guard coins >= amount else { return }
        coins -= amount
    }
}