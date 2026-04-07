//
//  ShopItemManager.swift
//  RedFox
//
//  Created by Илья Волощик on 13.10.25.
//


import Foundation
import Combine

final class 

ActionManagerSession: ObservableObject {
    static let shared = ActionManagerSession()
    private let storageKey = "shopItems"
    
    @Published var shopItems: [WriterWriterCheckerStore] = []
    
    private init (){
        loadShopItems()
    }
    
    func loadShopItems() {
        if let data = UserDefaults.standard.data(forKey: storageKey),
           let decoded = try? JSONDecoder().decode([WriterWriterCheckerStore].self, from: data) {
            self.shopItems = decoded
            updateStatus()
        } else {
            self.shopItems = defaultShopItems()
            saveShopItem()
        }
    }
    
    func saveShopItem() {
        if let encoded = try? JSONEncoder().encode(shopItems) {
            UserDefaults.standard.set(encoded, forKey: storageKey)
        }
    }
    
    func defaultShopItems() -> [WriterWriterCheckerStore] {
        return [
            WriterWriterCheckerStore(itemNumber: 1, price: 0, status: .available),
            WriterWriterCheckerStore(itemNumber: 2, price: 500, status: .locked),
            WriterWriterCheckerStore(itemNumber: 3, price: 100, status: .locked),
            WriterWriterCheckerStore(itemNumber: 4, price: 100, status: .locked),
        ]
    }
    
    func buyItem(number: Int) {
        guard let index = shopItems.firstIndex(where: {$0.itemNumber == number}) else {return}
        guard PresenterConnectorPresenterClientProcessor.shared.coins >= shopItems[index].price else {return}
        shopItems[index].status = .available
        PresenterConnectorPresenterClientProcessor.shared.spendCoins(shopItems[index].price)
        updateStatus()
    }
    
    func updateStatus() {
        let currenCoins = PresenterConnectorPresenterClientProcessor.shared.coins
        
            shopItems.forEach { item in
                
                if currenCoins >= item.price {
                    
                    switch item.status {
                        
                    case .locked:
                        shopItems[item.itemNumber-1].status = .readyToBuy
                    case .available:
                        shopItems[item.itemNumber-1].status = .available
                    case .readyToBuy:
                        shopItems[item.itemNumber-1].status = .readyToBuy
                    }
                } else {
                    
                    shopItems.forEach { item in
                        
                        switch item.status {
                            
                        case .locked:
                            shopItems[item.itemNumber-1].status = .locked
                        case .available:
                            shopItems[item.itemNumber-1].status = .available
                        case .readyToBuy:
                            shopItems[item.itemNumber-1].status = .locked
                        }
                    }
                }
            }
        saveShopItem()
    }
}


struct 


WriterWriterCheckerStore: Codable {
    let itemNumber: Int
    let price: Int
    var status: ShopItemStatus
}

enum ShopItemStatus: String, Codable {
    case locked
    case available
    case readyToBuy
}
