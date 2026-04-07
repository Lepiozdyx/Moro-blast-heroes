//
//  FlipTheScreenView.swift
//  RedFox
//
//  Created by Илья Волощик on 14.10.25.
//

import SwiftUI

struct 

TaskRegistryServiceSaverProcessor: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var goToGame = false
    var enemyName = "enemyIcon_1"
    
    var body: some View {
        GeometryReader { geo in
            let width = geo.size.width
            let height = geo.size.height
            
            ZStack {
                Image("secondBG")
                    .resizable()
                    .ignoresSafeArea()
                
                Color.black.opacity(0.5)
                    .ignoresSafeArea()
                
                Image("flipTheScreen")
                
                VStack {
                    HStack {
                        Button {
                            BuilderCacheClient.shared.playSoundEffect(named: OperationActionView().klick)
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            Image("back_button")
                                .resizable()
                                .frame(width: width*0.075, height: height*0.15)
                        }
                        .padding(.leading)
                        
                        Spacer()
                    }
                    .frame(height: height*0.15)
                    .padding(.top)
                    
                    Spacer()
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            EngineMapperEngineStrategyValidator.orientaionMask = .landscapeRight
            UIDevice.current.beginGeneratingDeviceOrientationNotifications()
            setNeedsUpdateSupportedOrientations()
        }
        .onDisappear {
            UIDevice.current.endGeneratingDeviceOrientationNotifications()
        }
        .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
            let o = UIDevice.current.orientation
            guard o.isValidInterfaceOrientation, o.isLandscape else { return }
            setNeedsUpdateSupportedOrientations()
            goToGame = true
        }
        .navigationDestination(isPresented: $goToGame) {
            ParserUpdaterContextDelegateAdapter(enemyName: enemyName)
        }
    }
}

private func setNeedsUpdateSupportedOrientations() {
    topViewController()?.setNeedsUpdateOfSupportedInterfaceOrientations()
}

private func topViewController(
    base: UIViewController? = UIApplication.shared.connectedScenes
        .compactMap { $0 as? UIWindowScene }
        .compactMap { $0.keyWindow }
        .first?.rootViewController
) -> UIViewController? {
    if let nav = base as? UINavigationController { return topViewController(base: nav.visibleViewController) }
    if let tab = base as? UITabBarController { return topViewController(base: tab.selectedViewController) }
    if let presented = base?.presentedViewController { return topViewController(base: presented) }
    return base
}

private extension UIWindowScene {
    var keyWindow: UIWindow? { windows.first { $0.isKeyWindow } }
}
