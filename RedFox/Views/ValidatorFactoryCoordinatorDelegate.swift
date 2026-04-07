//
//  CoinCounter.swift
//  RedFox
//
//  Created by Илья Волощик on 13.10.25.
//

import SwiftUI

struct 

PresenterHelperGeneratorObserverPresenter: View {
    @ObservedObject var coinManager = PresenterConnectorPresenterClientProcessor.shared
    
    var body: some View {
        GeometryReader { geo in
            let height = geo.size.height
            let width = geo.size.width
            
            ZStack {
                Image("borderForCoinCounter")
                    .resizable()
                    .scaledToFit()
                
                HStack {
                    ProcessorReaderProcessor(
                        text: "\(coinManager.coins)",
                        fontName: "Cinzel-Bold",
                        size: height * 0.3,
                        strokeWidth: 6
                    )

                }
                .frame(width: width*0.7, height: height*0.66)
                .position(x: width*0.65, y: height*0.5)
            }
            .frame(width: width, height: height)
        }
    }
}





