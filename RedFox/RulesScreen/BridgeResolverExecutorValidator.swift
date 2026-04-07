//
//  RulesView.swift
//  RedFox
//
//  Created by Илья Волощик on 14.10.25.
//

import SwiftUI

struct 

ClientSessionRunnerPresenter: View {
    @Environment(\.presentationMode) var presentationMode
    @State var page = 1
    
    var body: some View {
        GeometryReader { geo in
            let width = geo.size.width
            let height = geo.size.height
            
            ZStack {
                Image("secondBG")
                    .resizable()
                    .ignoresSafeArea()
                
                VStack {
                    HStack(alignment: .top, spacing: width*0.125) {
                        Button {
                            BuilderCacheClient.shared.playSoundEffect(named: OperationActionView().klick)
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            Image("back_button")
                                .resizable()
                                .frame(width: width*0.2, height: height*0.1)
                        }
                        .padding(.leading)
                        
                        Image("rules_title")
                            .resizable()
                            .frame(width: width*0.3, height: height*0.1)
                        
                        Spacer()
                    }
                    .frame(height: height*0.125)
                    .padding(.top, height*0.05)
                    
                    Spacer()
                    
                    Image("rules_\(page)")
                        .resizable()
                        .frame(width: width*0.8, height: height*0.6)
                    
                    Spacer()
                    
                    Button {
                        if page == 1 {
                            page = 2
                        } else {
                            page = 1
                        }
                    } label: {
                        Image(page == 1 ? "next_button" : "backOnFirstPage_button")
                            .resizable()
                            .frame(width: width*0.25, height: height*0.1)
                    }
                }
            }
            .frame(width: width)
            .frame(height: height)
        }
        .navigationBarBackButtonHidden(true)
    }
}
