import UIKit
import SwiftUI
@main
class 
AdapterObserverSaverCoordinatorStrategy: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var application: UIApplication?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.application = application
        showLoadingScreen()
        initApp()
        
        return true
    }
    
    func onGameStart()
    {
        let contentView = ManagerCoordinatorMapperUpdater(rootView: GeneratorTaskListenerGenerator())
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = contentView

        EngineMapperEngineStrategyValidator.orientaionMask = UIInterfaceOrientationMask.portrait

        if !UserDefaults.standard.bool(forKey: "FirstStartApp") {
            UserDefaults.standard.set(true, forKey: "FirstStartApp")
            UserDefaults.standard.set(1, forKey: "pickedModel")

            BuilderCacheClient.shared.playBackgroundMusic()
        } else {
            BuilderCacheClient.shared.playBackgroundMusic()
        }

        window?.makeKeyAndVisible()
    }
}

class 

ManagerCoordinatorMapperUpdater<Content: View>: UIHostingController<Content> {
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return EngineMapperEngineStrategyValidator.orientaionMask
    }

    override var shouldAutorotate: Bool {
        return EngineMapperEngineStrategyValidator.isAutoRotationEnabled
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
}

class 

EngineMapperEngineStrategyValidator
{
    public static var orientaionMask: UIInterfaceOrientationMask = .portrait
    public static var isAutoRotationEnabled: Bool = false
}
