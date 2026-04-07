//
//  SpriteViewContainer.swift
//  RedFox
//
//  Created by Илья Волощик on 14.10.25.
//


import UIKit
import SwiftUI
import SpriteKit

struct 

ConverterValidatorModel: View {
    let id: UUID
    let enemyName: String
    @ObservedObject var viewModel: ObserverContextGeneratorValidator
    
    var body: some View {
        let scene = MapperProviderRunnerEngine(enemyName: enemyName)
        scene.size = UIScreen.main.bounds.size
        scene.scaleMode = .resizeFill
        scene.gameViewModel = viewModel
        scene.backgroundColor = .clear
        return ObserverRepositoryManagerHelperRegistry(scene: scene)
            .id(id)
    }
}
