  //
//  AppDelegate.swift
//  GTUICatalog
//
//  Created by liuxc on 2018/11/6.
//  Copyright © 2018 liuxc. All rights reserved.
//

import UIKit
import GTUIKit
import GTCatalog

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GTUINavigationControllerDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        var rootNodeViewController: UIViewController!
        rootNodeViewController = GTFNodeListViewController(node: GTFCreateNavigationTree())

        let navigationController = GTUINavigationController(rootViewController: rootNodeViewController)
        let appBarController = navigationController.naviBarViewController(for: rootNodeViewController)
        setupDefaultNaviBackground(appBarViewController: appBarController!)
        navigationController.delegate = self
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
        return true
    }

    func navigationController(_ navigationController: GTUINavigationController, willAdd appBarViewController: GTUIAppBarViewController, asChildOf viewController: UIViewController) {
        appBarViewController.headerView.backgroundColor = UIColor.yellow
        setupDefaultNaviBackground(appBarViewController: appBarViewController)
    }

    func setupDefaultNaviBackground(appBarViewController: GTUIAppBarViewController) {
        let navImageView = UIImageView(image: UIImage(named: "titlebg"))
        navImageView.frame = appBarViewController.headerView.bounds;
        navImageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        appBarViewController.headerView.insertSubview(navImageView, at: 0)
        appBarViewController.navigationBar.setButtonsTitleColor(UIColor.black, for: .normal)
        appBarViewController.navigationBar.tintColor = UIColor.black
        appBarViewController.headerView.canOverExtend = false
        appBarViewController.headerView.resetShadowAfterTrackingScrollViewIsReset = true
    }

}

