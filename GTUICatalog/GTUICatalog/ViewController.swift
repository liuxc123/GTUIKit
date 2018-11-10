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

    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
//        customView = ShapesShadows(frame: CGRect(x: 0, y: 300, width: 100, height: 100))
//        customView.center = CGPoint(x: self.view.center.x, y: 50)
//        self.view.addSubview(customView)
//
//        UIView.animate(withDuration: 2.0, delay: 0, options: [], animations:{
//            self.customView.center = CGPoint(x: self.view.center.x, y: self.view.center.y)
//        }, completion: nil)


//        let btn = GTUIButton(frame: CGRect(x: 0, y: 200, width: 100, height: 40))
//        btn.setBorderWidth(5, for: .normal)
//        btn.setBorderColor(UIColor.red, for: .normal)
//        btn.setTitleShadowColor(UIColor.yellow, for: .normal)
//        btn.setTitle("标题", for: .normal)
//        self.view.addSubview(btn)
//        let pathurl = Bundle.main.url(forResource: "iconfont", withExtension: "ttf")
//        UIImage.registerIconFont("iconfont", fontPathURL: pathurl!)

        let iconView = GTUIIconView(frame: CGRect(x: 50, y: 200, width: 40, height: 40), name: "\u{e96b}", fontName: "iconfont")
        self.view.addSubview(iconView!)



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


        self.commonInit()

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
        let shapeGenerator = GTUICurvedRectShapeGenerator()
        shapeGenerator.cornerSize = CGSize(width: 20, height: 10)
//        shapeGenerator.setCorners(GTUIRoundedCornerTreatment(radius: 10))
//        let cutCornerTreatment = GTUITriangleEdgeTreatment(size: 10, style: GTUITriangleEdgeStyleHandle)
//        let borderTreatment = GTUIBorderEdgeTreatment(borderWidth: 10, borderColor: UIColor.blue)
//        shapeGenerator.setEdges(borderTreatment)
        layer.shapeGenerator = shapeGenerator
        layer.shapedBackgroundColor = .red
        layer.shadowOffset = CGSize(width: 0, height: -3)
        layer.shadowRadius = 4
        layer.shadowOpacity = 0.4
    }
}

