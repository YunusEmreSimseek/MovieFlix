//
//  Tabs.swift
//  MovieFlix
//
//  Created by Emre Simsek on 6.10.2025.
//
import UIKit

enum MainTabs: Int, CaseIterable {
    case home
    case login
    
    var configureTab: UINavigationController {
        let nc = UINavigationController(rootViewController: self.viewController)
        nc.tabBarItem.image = self.icon
        nc.tabBarItem.title = self.title
        return nc
    }
    
    private var viewController: UIViewController {
        switch self {
        case .login:
            LoginView()
        case .home:
            NewHomeViewController()
        }
    }
    
    private var icon: UIImage? {
        switch self {
        case .login:
            UIImage(systemName: "person")
        case .home:
            UIImage(systemName: "house")
        }
    }
    
    private var title: String {
        switch self {
        case .login:
            "Login"
        case .home:
            "Home"
        }
    }
}
