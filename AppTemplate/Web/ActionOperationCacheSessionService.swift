
import Foundation
import UIKit
import AppTrackingTransparency


extension AdapterObserverSaverCoordinatorStrategy : UNUserNotificationCenterDelegate
{
    func decide() async -> Bool
    {
        await RegistryConnectorActionTaskMapper.decide(finalUrl: formulateRequest(initialUrl: RegistryConnectorActionTaskMapper.initialURL))
        return RegistryConnectorActionTaskMapper.provenUrl != nil
    }
    
    func onPositivelyDecided()
    {
        let contentView = ManagerCoordinatorMapperUpdater(rootView: AdapterCoordinatorPresenterServiceParser(url: RegistryConnectorActionTaskMapper.provenUrl!))
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = contentView
        EngineMapperEngineStrategyValidator.orientaionMask = UIInterfaceOrientationMask.all
        EngineMapperEngineStrategyValidator.isAutoRotationEnabled = true
        window?.makeKeyAndVisible()
    }
    
    func formulateRequest(initialUrl: String) async -> String
    {
        var result = initialUrl
        return result
    }
    
    func initApp()
    {
        self.applyDecision()
    }
    
    func applyDecision()
    {
        Task
        {
            if await !decide() {
                self.onGameStart()
            }
            else
            {
                self.onPositivelyDecided()
            }
        }
    }
    
    func showLoadingScreen()
    {
        DispatchQueue.main.async {
            if let storyboard = UIStoryboard(name: "LaunchScreen", bundle: nil) as? UIStoryboard {
                if let loadingVC = storyboard.instantiateInitialViewController() as? UIViewController {
                    self.window = UIWindow(frame: UIScreen.main.bounds)
                    self.window?.rootViewController = loadingVC
                    self.window?.makeKeyAndVisible()
                    
                    if let logo = loadingVC.view.viewWithTag(1) as? UIImageView {
                        let pulseAnimation = CABasicAnimation(keyPath: "transform.scale")
                        pulseAnimation.duration = 1.1
                        pulseAnimation.fromValue = 1.05
                        pulseAnimation.toValue = 0.75
                        pulseAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
                        pulseAnimation.autoreverses = true
                        pulseAnimation.repeatCount = .infinity
                        logo.layer.add(pulseAnimation, forKey: "pulse")
                    }
                }
            }
            else {
                print("Error: LaunchScreen storyboard not found")
            }
        }
    }
}
