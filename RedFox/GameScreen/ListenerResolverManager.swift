//
//  TransparentSpriteView.swift
//  RedFox
//
//  Created by Илья Волощик on 14.10.25.
//


import SpriteKit
import SwiftUI

struct 

ObserverRepositoryManagerHelperRegistry: UIViewRepresentable {
    let scene: SKScene
    
    func makeUIView(context: Context) -> SKView {
        let skView = SKView()
        skView.allowsTransparency = true
        skView.backgroundColor = .clear
        skView.presentScene(scene)
        return skView
    }
    
    func updateUIView(_ uiView: SKView, context: Context) {
    }
}
