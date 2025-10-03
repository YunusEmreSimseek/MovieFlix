//
//  NavigationManager.swift
//  MovieFlix
//
//  Created by Emre Simsek on 3.10.2025.
//
import UIKit

final class NavigationManager {
    static let shared = NavigationManager()
    private var nav: UINavigationController?
    private init() {}

    func setRootNav(_ nav: UINavigationController) {
        self.nav = nav
    }

    func push(_ vc: UIViewController, animated: Bool = true) {
        nav?.pushViewController(vc, animated: animated)
        print(nav?.viewControllers)
    }

    func present(_ vc: UIViewController, animated: Bool = true) {
        nav?.present(vc, animated: animated)
    }

    func pop(animated: Bool = true) {
        nav?.popViewController(animated: animated)
    }
}
