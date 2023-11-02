//
//  TabBarController.swift
//  Tracker-ios
//
//  Created by Iurii on 09.10.23.
//

import UIKit

final class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let trackersViewController = TrackersViewController()
        trackersViewController.tabBarItem = UITabBarItem(
            title: "Трекеры",
            image: UIImage(named: "TabBarTrackers"),
            selectedImage: nil
        )
        
        view.backgroundColor = .white
        
        let statisticsViewController = StatisticsViewController()
        statisticsViewController.tabBarItem = UITabBarItem(
            title: "Cтатистика",
            image: UIImage(named: "TabBarStats"),
            selectedImage: nil
        )
        
        self.viewControllers = [trackersViewController, statisticsViewController]
        
        tabBarLine()
    }
    
    private func tabBarLine() {
        tabBar.layer.borderWidth = 1
        tabBar.layer.borderColor = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.2).cgColor
        tabBar.clipsToBounds = true
    }
}
