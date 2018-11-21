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

    lazy var textField = GTUITextField()
    var textFieldController: GTUITextInputControllerFullWidth!
    let textView = GTUIMultilineTextField()
    var textViewController: GTUITextInputControllerUnderline!


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)


    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        title = "子标题"
        self.addChildViewController(appBarViewController)
        self.view.addSubview(self.appBarViewController.view);
        appBarViewController.didMove(toParentViewController: self)
        appBarViewController.navigationBar.titleAlignment = .center
        appBarViewController.navigationBar.setButtonsTitleColor(UIColor.black, for: .normal)
        appBarViewController.headerView.backgroundColor = UIColor.yellow
        titleView?.center.x = appBarViewController.navigationBar.center.x;
        appBarViewController.navigationBar.titleView = titleView
        appBarViewController.navigationBar.titleViewLayoutBehavior = GTUINavigationBarTitleViewLayoutBehavior.center;
        titleView?.updateTitleFont(UIFont.systemFont(ofSize: 30))
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

        textField.autocapitalizationType = .words
        self.view.addSubview(textField)


        textFieldController = GTUITextInputControllerFullWidth(textInput: textField)
        textFieldController.placeholderText = "placeholder"
        textFieldController.characterCountMax = 25

//        let underLineController = GTUITextInputControllerOutlined(textInput: textField)
//        underLineController.placeholderText = "System Font"
//        underLineController.characterCountMax = 25
//        underLineController.


        textView.backgroundColor = UIColor.yellow
        textView.hidesPlaceholderOnInput = true
        self.view.addSubview(textView)

        textViewController = GTUITextInputControllerUnderline(textInput: textView)
        textViewController.placeholderText = "GTUITextInputControllerUnderline"
        textViewController.isFloatingEnabled = false


        textField.mas_makeConstraints { (make) in
            make?.top.equalTo()(self.view.mas_top)?.setOffset(appBarViewController.headerView.frame.size.height + 20)
            make?.right.equalTo()(self.view.mas_right)
            make?.left.equalTo()(self.view.mas_left)
        }

        textView.mas_makeConstraints { (make) in
            make?.top.equalTo()(textField.mas_bottom)?.setOffset(20)
            make?.centerX.equalTo()(self.view.mas_centerX)
            make?.width.setOffset(self.view.frame.size.width)
            make?.height.setOffset(200)
        }

    }



}
