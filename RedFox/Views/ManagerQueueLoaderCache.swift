//
//  IconButton.swift
//  RedFox
//
//  Created by Илья Волощик on 13.10.25.
//


import SwiftUI

struct 

HelperContextWriterManager<Destination: View>: View {
    let imageName: String
    let destination: Destination
    var action: (() -> Void)? = nil
    
    var body: some View {
        GeometryReader { geo in
            let minSide = min(geo.size.width, geo.size.height)
            let buttonSize = minSide
            
            Button(action: {
                BuilderCacheClient.shared.playSoundEffect(named: OperationActionView().klick)
                action?()
            }) {
                NavigationLink(destination: destination) {
                    Image(imageName)
                        .resizable()
                        .scaledToFill()
                        .frame(width: buttonSize, height: buttonSize)
                }
                .aspectRatio(contentMode: .fit)
                .buttonStyle(PlainButtonStyle())
                .simultaneousGesture(TapGesture().onEnded {
                    BuilderCacheClient.shared.playSoundEffect(named: OperationActionView().klick)
                })
            }
        }
    }
}