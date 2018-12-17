//
//  FormOtherRowsViewController.swift
//  GTCatalog
//
//  Created by liuxc on 2018/12/17.
//

import UIKit
import GTUIKit

class FormOtherRowsViewController: GTUIFormViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.title = "Other Rows"
        initForm()
    }


    func initForm() {
        var form: GTUIFormDescriptor
        var section: GTUIFormSectionDescriptor
        var row: GTUIFormRowDescriptor

        form = GTUIFormDescriptor()

        section = GTUIFormSectionDescriptor()
        section.headerHeight = 20
        form.addFormSection(section)

        row = GTUIFormRowDescriptor(tag: "手机号", rowType: GTUIFormRowDescriptorTypePhone, title: "手机号")
        row.height = 50
        section.addFormRow(row)
        
        row = GTUIFormRowDescriptor(tag: "倒计时", rowType: GTUIFormRowDescriptorTypeCountDownCode, title: "验证码")
        row.height = 50
        row.action.formBlock = { [unowned self] sender in
            let cell = row.cell(forForm: self) as? GTUIFormCodeCell
            cell?.startCountDown(withTimeOut: 60)
        }
        section.addFormRow(row)

        self.form = form
    }

}

extension FormOtherRowsViewController {
    @objc class func catalogMetadata() -> [String: Any] {
        return [
            "breadcrumbs": ["Form", "Other Rows"],
            "primaryDemo": true,
            "presentable": true
        ]
    }
}
