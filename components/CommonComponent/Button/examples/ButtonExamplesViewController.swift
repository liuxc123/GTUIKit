//
//  ButtonExamplesViewController.swift
//  GTCatalog
//
//  Created by liuxc on 2018/12/28.
//

import UIKit
import GTUIKit

class ButtonExamplesViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.title = "buttons"


        buttonExample1()
    }


    func buttonExample1() {
        let btn = GTUIButton(frame: CGRect(x: 0, y: 200, width: 100, height: 80))
        btn.setBackgroundColor(UIColor.red, for: .normal)
        //        btn.setBorderWidth(5, for: .normal)
        //        btn.setBorderColor(UIColor.red, for: .normal)
        btn.setTitleShadowColor(UIColor.yellow, for: .normal)
        btn.setImage(UIImage(named: "Add"), for: .normal)
        btn.setTitle("标题", for: .normal)
        btn.setTitleColor(UIColor.black, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        btn.addTarget(self, action: #selector(btnClickAction(_:)), for: .touchUpInside)
//        btn.imageLocation = .leading
        btn.imageTitleSpace = 2
        self.view.addSubview(btn)

        btn.sizeToFit()
    }



    @objc func btnClickAction(_ sender: UIButton) {
        print("按钮点击")
    }

}


extension ButtonExamplesViewController {
    @objc class func catalogMetadata() -> [String: Any] {
        return [
            "breadcrumbs": ["Button", "buttons"],
            "primaryDemo": true,
            "presentable": true
        ]
    }
}
