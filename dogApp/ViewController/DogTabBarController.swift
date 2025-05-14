//
//  DogTabBarController.swift
//  dogApp
//
//  Created by eloddobos on 2025-05-14.
//

import Foundation
import UIKit

class DogTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dogListVC = DogListViewController()
        let dogImageVC = DogImageViewController()

        let dogListNav = UINavigationController(rootViewController: dogListVC)
        let dogImageNav = UINavigationController(rootViewController: dogImageVC)

        dogListNav.tabBarItem = UITabBarItem(title: "Dog List", image: UIImage(systemName: "list.bullet.rectangle"), tag: 0)
        dogImageNav.tabBarItem = UITabBarItem(title: "Favorite Images", image: UIImage(systemName: "star.square.on.square"), tag: 1)

        viewControllers = [dogImageNav, dogListNav]
        self.tabBar.backgroundColor = .white
    }
}

