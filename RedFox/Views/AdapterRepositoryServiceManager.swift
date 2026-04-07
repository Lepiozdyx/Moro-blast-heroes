//
//  NavigationButton.swift
//  RedFox
//
//  Created by Илья Волощик on 13.10.25.
//


import SwiftUI

struct 

ContextListenerObserverHelper<Destination: View>: View {
    let imageName: String
    let destination: Destination
    
    var body: some View {
        NavigationLink(destination: destination) {
            GeometryReader { geo in
                ZStack {
                    Image(imageName)
                        .resizable()
                        .frame(maxWidth: geo.size.width, maxHeight: geo.size.height)
                        .clipped()
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
        .simultaneousGesture(TapGesture().onEnded {
            BuilderCacheClient.shared.playSoundEffect(named: OperationActionView().klick)
        })
    }
}