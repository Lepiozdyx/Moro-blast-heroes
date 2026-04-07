//
//  SettingsView.swift
//  RedFox
//
//  Created by Илья Волощик on 14.10.25.
//

import SwiftUI

struct 

MapperCheckerAdapterStrategyProvider: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var settings = AdapterTaskHandlerHelper.shared
    
    var body: some View {
        GeometryReader { geo in
            let width = geo.size.width
            let height = geo.size.height
            
            ZStack {
                Image("secondBG")
                    .resizable()
                    .ignoresSafeArea()
                
                VStack {
                    HStack(alignment: .center, spacing: width*0.1) {
                        Button {
                            BuilderCacheClient.shared.playSoundEffect(named: OperationActionView().klick)
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            Image("back_button")
                                .resizable()
                                .frame(width: width*0.2, height: height*0.1)
                        }
                        .padding(.leading)
                        
                        Image("settings_title")
                            .resizable()
                            .frame(width: width*0.4, height: height*0.025)
                        
                        Spacer()
                    }
                    .frame(height: height*0.1)
                    .padding(.top)
                    
                    Spacer()
                }
                
                ZStack {
                    Image("settings_border")
                        .resizable()
                        .frame(width: width*0.8, height: height*0.5)
                    
                    VStack(spacing: height*0.05) {
                        Image("music_label")
                            .resizable()
                            .frame(width: width*0.3, height: height*0.04)
                        
                        Button {
                            BuilderCacheClient.shared.playSoundEffect(named: OperationActionView().klick)
                            settings.musicVolume.toggle()
                        } label: {
                            Image(settings.musicVolume ? "sound_on" : "sound_off")
                                .resizable()
                                .frame(width: width*0.6, height: height*0.1)
                        }
                        
                        Image("sound_label")
                            .resizable()
                            .frame(width: width*0.3, height: height*0.04)
                        
                        Button {
                            BuilderCacheClient.shared.playSoundEffect(named: OperationActionView().klick)
                            settings.soundVolume.toggle()
                        } label: {
                            Image(settings.soundVolume ? "sound_on" : "sound_off")
                                .resizable()
                                .frame(width: width*0.6, height: height*0.1)
                        }
                    }
                }
            }
            .frame(width: width)
            .frame(height: height)
        }
        .navigationBarBackButtonHidden(true)
    }
}
