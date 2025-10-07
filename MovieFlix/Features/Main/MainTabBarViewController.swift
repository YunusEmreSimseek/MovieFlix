//
//  MainTabBarViewController.swift
//  MovieFlix
//
//  Created by Emre Simsek on 6.10.2025.
//
import UIKit

final class MainTabBarViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()

        let viewNavigationControllers = MainTabs.allCases.map { $0.configureTab }
        setViewControllers(viewNavigationControllers, animated: true)
//        tabBar.tintColor = .systemRed
    }
}

#Preview {
    MainTabBarViewController()
}
