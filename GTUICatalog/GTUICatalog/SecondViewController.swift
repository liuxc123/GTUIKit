//
//  SecondViewController.swift
//  GTUICatalog
//
//  Created by liuxc on 2018/11/20.
//  Copyright © 2018 liuxc. All rights reserved.
//

import UIKit
import GTUIKit

class SecondViewController: UIViewController {

    lazy var appBarViewController: GTUIAppBarViewController = {
        let appBarViewController = GTUIAppBarViewController()
        appBarViewController.inferPreferredStatusBarStyle = true
        appBarViewController.headerView.minMaxHeightIncludesSafeArea = false
        return appBarViewController
    }()

    var titleView = GTUIDoubleTitleView(title: "标题", detailTitle: "副标题")
    var toolBarView = GTUIToolBarView()


    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        title = "子标题"
        self.addChildViewController(appBarViewController)
        self.view.addSubview(self.appBarViewController.view);
        appBarViewController.didMove(toParentViewController: self)
        appBarViewController.navigationBar.setButtonsTitleColor(UIColor.black, for: .normal)
        appBarViewController.headerView.backgroundColor = UIColor.yellow

        appBarViewController.navigationBar.hidesBackButton = true
        appBarViewController.navigationBar.titleView = titleView

        toolBarView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        view.addSubview(toolBarView)

        let size = toolBarView.sizeThatFits(view.bounds.size)
        let bottomBarViewFrame = CGRect(x: 0,
                                        y: view.bounds.size.height - size.height,
                                        width: size.width,
                                        height: size.height)
        toolBarView.frame = bottomBarViewFrame

        let addImage = UIImage(named:"Add")?.withRenderingMode(.alwaysTemplate)
        toolBarView.floatingButton.setImage(addImage, for: .normal)

        // Set the position of the floating button.
        toolBarView.floatingButtonPosition = .center

    }



}
