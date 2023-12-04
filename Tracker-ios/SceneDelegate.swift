//
//  SceneDelegate.swift
//  Tracker-ios
//
//  Created by Iurii on 01.10.23.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: scene)
        let onboardingShown = UserDefaults.standard.bool(forKey: "hasShownOnboarding")
        
        if !onboardingShown {
            let onboardingViewController = OnboardingViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
            window.rootViewController = onboardingViewController
        } else {
            let mainViewController = TabBarController()
            window.rootViewController = mainViewController
        }
        
        self.window = window
        window.makeKeyAndVisible()
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
}
