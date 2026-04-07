//
//  FindEnemyForGameView.swift
//  RedFox
//
//  Created by Илья Волощик on 15.10.25.
//

import SwiftUI
import Combine

struct 

RegistryLoaderPresenterHelper: View {
    @Environment(\.presentationMode) var presentationMode
    
    private let enemies: [RepositoryExecutorCache] = [
        .init(name: "CISSO", imageName: "enemyIcon_1"),
        .init(name: "RAZOR", imageName: "enemyIcon_2"),
        .init(name: "BLAZE", imageName: "enemyIcon_3"),
        .init(name: "NYX",   imageName: "enemyIcon_4")
    ]
    
    private let startDelay: TimeInterval = 0.6
    private let totalDuration: TimeInterval = 5.0
    private let spinDuration: TimeInterval  = 3.0
    private let frameDuration: TimeInterval = 0.2
    
    @State private var timerCancellable: AnyCancellable?
    @State private var pendingWork: DispatchWorkItem?
    @State private var startedAt: Date?
    @State private var lockedAt: Date?
    @State private var currentEnemyIndex = 0
    
    @State private var enemyName: String?
    
    @State private var disablePlayButton = true
    var body: some View {
        GeometryReader { geo in
            let width = geo.size.width
            let height = geo.size.height
            
            ZStack {
                Image("findEnemy_Background")
                    .resizable()
                    .ignoresSafeArea()
                
                
                ZStack {
                    HStack {
                        VStack(alignment: .leading) {
                            ProcessorReaderProcessor(
                                text: "MARIN",
                                fontName: "Cinzel-Bold",
                                size: height * 0.05,
                                strokeWidth: 6
                            )
                            
                            Spacer()
                            
                            Image("playerIcon_\(UserDefaults.standard.integer(forKey: "pickedModel"))")
                                .resizable()
                                .scaledToFit()
                        }
                        .frame(width: width*0.45, height: height*0.4)
                        
                        Spacer()
                        
                        VStack(alignment: .trailing) {
                            ProcessorReaderProcessor(
                                text: enemies[currentEnemyIndex].name,
                                fontName: "Cinzel-Bold",
                                size: height * 0.05,
                                strokeWidth: 6
                            )
                            .id("name\(currentEnemyIndex)")
                            .transition(.opacity)
                            .animation(.easeInOut(duration: 0.18), value: currentEnemyIndex)
                            
                            Spacer()
                            
                            Image(enemies[currentEnemyIndex].imageName)
                                .resizable()
                                .scaledToFit()
                                .id("img\(currentEnemyIndex)")
                                .transition(.opacity)
                                .animation(.easeInOut(duration: 0.18), value: currentEnemyIndex)
                        }
                        .frame(width: width*0.45, height: height*0.4)
                        
                    }
                    .frame(width: width, height: height*0.35)
                    .offset(y: -height*0.175)
                    
                    
                    VStack(spacing: height*0.03) {
                        HStack {
                            Button {
                                BuilderCacheClient.shared.playSoundEffect(named: OperationActionView().klick)
                                presentationMode.wrappedValue.dismiss()
                            } label: {
                                Image("back_button")
                                    .resizable()
                                    .frame(width: width*0.2, height: height*0.1)
                            }
                            .padding(.leading)
                            
                            Spacer()
                        }
                        .frame(height: height*0.15)
                        .padding(.top)
                        
                        Spacer()
                        
                        ContextListenerObserverHelper(imageName: "play_button", destination: TaskRegistryServiceSaverProcessor(enemyName: enemyName ?? "enemyIcon_1"))
                            .frame(width: width*0.6, height: height*0.15)
                            .padding(.bottom)
                            .disabled(disablePlayButton)
                    }
                }
            }
            .frame(width: width)
            .frame(height: height)
        }
        .navigationBarBackButtonHidden(true)
        .onAppear{
            EngineMapperEngineStrategyValidator.orientaionMask = .portrait
            startSpin()
            
        }
    }
    
    private func startSpin() {
        stopSpin()

        let work = DispatchWorkItem {
            guard !self.enemies.isEmpty else { return }
            self.currentEnemyIndex = Int.random(in: 0..<self.enemies.count)
            self.startedAt = Date()
            self.lockedAt = nil

            let start = Date()
            self.timerCancellable = Timer.publish(every: self.frameDuration, on: .main, in: .common)
                .autoconnect()
                .sink { now in
                    let t = now.timeIntervalSince(start)
                    if t < self.spinDuration {
                        self.currentEnemyIndex = (self.currentEnemyIndex + 1) % self.enemies.count
                    } else {
                        if self.lockedAt == nil {
                            self.lockedAt = now
                            self.enemyName = self.enemies[self.currentEnemyIndex].imageName
                        }
                        if let s = self.startedAt, now.timeIntervalSince(s) >= self.totalDuration {
                            self.stopSpin()
                            self.disablePlayButton = false
                        }
                    }
                }
        }
        self.pendingWork = work
        DispatchQueue.main.asyncAfter(deadline: .now() + self.startDelay, execute: work)
    }

    private func stopSpin() {
        timerCancellable?.cancel()
        timerCancellable = nil
        pendingWork?.cancel()
        pendingWork = nil
    }
}

struct 

RepositoryExecutorCache{
    let name: String
    let imageName: String
}

struct 

HelperSaverOperationWriter: PreviewProvider {
    static var previews: some View {
        RegistryLoaderPresenterHelper()
    }
}
