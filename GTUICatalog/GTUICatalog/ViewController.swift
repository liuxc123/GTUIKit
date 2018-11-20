//
//  ViewController.swift
//  GTUICatalog
//
//  Created by liuxc on 2018/11/6.
//  Copyright © 2018 liuxc. All rights reserved.
//

import UIKit
import GTUIKit

class ViewController: UIViewController {

    var customView: ShapesShadows!

    var fhvc: GTUIFlexibleHeaderViewController!

    var scrollView: UIScrollView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.title = "标题"
//        self.navigationController?.setNavigationBarHidden(true, animated: false)

//        customView = ShapesShadows(frame: CGRect(x: 0, y: 300, width: 100, height: 100))
//        customView.center = CGPoint(x: self.view.center.x, y: 50)
//        self.view.addSubview(customView)
//
//        UIView.animate(withDuration: 2.0, delay: 0, options: [], animations:{
//            self.customView.center = CGPoint(x: self.view.center.x, y: self.view.center.y)
//        }, completion: nil)


        let btn = GTUIButton(frame: CGRect(x: 0, y: 200, width: 414, height: 40))
        btn.setBackgroundColor(UIColor.red, for: .normal)
//        btn.setBorderWidth(5, for: .normal)
//        btn.setBorderColor(UIColor.red, for: .normal)
        btn.setTitleShadowColor(UIColor.yellow, for: .normal)
        btn.setImage(UIImage(named: "Add"), for: .normal)
        btn.setTitle("标题", for: .normal)
        btn.addTarget(self, action: #selector(btnClickAction(_:)), for: .touchUpInside)
        btn.imageLocation = .leading
        btn.imageTitleSpace = 2
        self.view.addSubview(btn)


        let actionItem = UIBarButtonItem(image: UIImage(named: "Cake")?.withRenderingMode(.alwaysTemplate), style: .done, target: self, action: nil)
        let secondActionItem = UIBarButtonItem(image: UIImage(named: "Add")?.withRenderingMode(.alwaysTemplate), style: .done, target: self, action: nil)
        let actionItem1 = UIBarButtonItem(title: "Action", style: .done, target: self, action: nil)
//        let actionItem2 = UIBarButtonItem(title: "Second Action", style: .done, target: self, action: nil)

//        self.navigationBar = GTUINavigationBar(frame: CGRect(x: 0, y: 100, width: UIScreen.main.bounds.width, height: 44))
//        self.navigationBar.backgroundColor = UIColor.lightGray
//        self.navigationBar.titleAlignment = .center
//        self.navigationBar.observe(self.navigationItem)
//        self.view.addSubview(self.navigationBar)


        self.navigationItem.hidesBackButton = false
        if #available(iOS 11.0, *) {
            self.navigationItem.largeTitleDisplayMode = .always
        } else {
            // Fallback on earlier versions
        }
        self.navigationItem.leftBarButtonItems = [actionItem, secondActionItem]
        self.navigationItem.rightBarButtonItems = [actionItem1]


//        let buttonBar = GTUIButtonBar()
//        buttonBar.inkColor = UIColor.black
//        self.view.addSubview(buttonBar)
//
//        buttonBar.backgroundColor = UIColor.blue
//        buttonBar.tintColor = UIColor.white
//
//        buttonBar.frame = CGRect(x: 0, y: 300, width: UIScreen.main.bounds.size.width, height: 50)
//

//
//        buttonBar.items = [actionItem, secondActionItem, actionItem1, actionItem2]


//        let pathurl = Bundle.main.url(forResource: "iconfont", withExtension: "ttf")
//        UIImage.registerIconFont("iconfont", fontPathURL: pathurl!)

//        let iconView = GTUIIconView(frame: CGRect(x: 50, y: 200, width: 40, height: 40), name: "\u{e96b}", fontName: "iconfont")
//        self.view.addSubview(iconView!)



//        self.view.addSubview(self.defaultCheckBox)
//        self.view.addSubview(self.charkmarkCheckBox)
//        self.view.addSubview(self.squareCheckBox)
//
//
//        self.defaultCheckBox.frame = CGRect(x: 100, y: 100, width: 40, height: 40);
//        self.charkmarkCheckBox.frame = CGRect(x: 100, y: 200, width: 40, height: 40);
//        self.squareCheckBox.frame = CGRect(x: 100, y: 300, width: 40, height: 40);
//
//        self.defaultCheckBox.reload()
//        self.charkmarkCheckBox.reload()
//        self.squareCheckBox.reload()
//        self.checkBoxGroup.mustHaveSelection = false


//        fhvc = GTUIFlexibleHeaderViewController(nibName: nil, bundle: nil)
//
//        // Behavioral flags.
//        fhvc.isTopLayoutGuideAdjustmentEnabled = true
//        fhvc.inferTopSafeAreaInsetFromViewController = true
//        fhvc.headerView.minMaxHeightIncludesSafeArea = false
//
//        fhvc.headerView.maximumHeight = 64
//        fhvc.headerView.minimumHeight = 44
//
//        fhvc.headerView.backgroundColor = UIColor.yellow
//        self.addChildViewController(fhvc)
//
//        self.scrollView = UIScrollView(frame: self.view.bounds)
//        self.scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        self.view.addSubview(self.scrollView)
//        self.scrollView.contentSize = self.view.bounds.size;

//
//        self.scrollView.delegate = self.fhvc
//        self.fhvc.headerView.trackingScrollView = self.scrollView
//
//        self.fhvc.view.frame = self.view.bounds
//        self.view.addSubview(fhvc.view)
//        self.fhvc.didMove(toParentViewController: self)
//
        self.commonInit()

    }

    @objc func btnClickAction(_ sender: GTUIButton) {

        let vc = SecondViewController()
        vc.view.backgroundColor = UIColor.white
        vc.title = "子标题"
        self.navigationController?.pushViewController(vc, animated: true)

    }


    func commonInit() {
        guard let layer = self.view.layer as? GTUIShapedShadowLayer else {
            return
        }
        let shapeGenerator = GTUIRectangleShapeGenerator()
        shapeGenerator.topLeftCorner = GTUICutCornerTreatment(cut: 20)
        layer.shapeGenerator = shapeGenerator
        layer.shapedBackgroundColor = .red
        layer.shadowOffset = CGSize(width: 0, height: -3)
        layer.shadowRadius = 4
        layer.shadowOpacity = 0.4
    }


    lazy var defaultCheckBox: GTUICheckBox = {
        let checkBox = GTUICheckBox(type: .circle);
        return checkBox
    }()

    lazy var charkmarkCheckBox: GTUICheckBox = {
        let checkBox = GTUICheckBox(type: .checkmark);
        return checkBox
    }()

    lazy var squareCheckBox: GTUICheckBox = {
        let checkBox = GTUICheckBox(type: .square);
        return checkBox
    }()

    lazy var checkBoxGroup = GTUICheckBoxGroup(checkBoxes: [defaultCheckBox, charkmarkCheckBox, squareCheckBox])

}


class ShapesShadows: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    override class var layerClass: AnyClass {
        get {
            return GTUIShapedShadowLayer.self
        }
    }

    func commonInit() {
        guard let layer = layer as? GTUIShapedShadowLayer else {
            return
        }
        let shapeGenerator = GTUIRectangleShapeGenerator()


//        shapeGenerator.cornerSize = CGSize(width: 20, height: 10)
//        shapeGenerator.setCorners(GTUIRoundedCornerTreatment(radius: 10))
        let cutCornerTreatment = GTUITriangleEdgeTreatment(size: 10, style: GTUITriangleEdgeStyleHandle)
//        let borderTreatment = GTUIBorderEdgeTreatment(borderWidth: 10, borderColor: UIColor.blue)
//        shapeGenerator.setEdges(borderTreatment)
        shapeGenerator.topEdge = cutCornerTreatment


        layer.shapeGenerator = shapeGenerator
        layer.shapedBackgroundColor = .red
        layer.shadowOffset = CGSize(width: 0, height: -3)
        layer.shadowRadius = 4
        layer.shadowOpacity = 0.4
    }
}

