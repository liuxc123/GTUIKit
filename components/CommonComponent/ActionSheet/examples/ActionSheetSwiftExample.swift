//
//  ActionSheetSwiftExample.swift
//  GTCatalog
//
//  Created by liuxc on 2018/11/23.
//

import UIKit
//import GTUIKit
//
//class ActionSheetSwiftExample: UIViewController {
//
//    let tableView = UITableView()
//    enum ActionSheetExampleType {
//        case typical, title, message, noIcons, titleAndMessage, dynamicType, delayed, thirtyOptions, system
//    }
//    typealias ExamplesTuple = (label: String, type: ActionSheetExampleType)
//    let data: [ExamplesTuple] = [
//        ("Typical Use", .typical),
//        ("Title only", .title),
//        ("Message only", .message),
//        ("No Icons", .noIcons),
//        ("With Title and Message", .titleAndMessage),
//        ("Dynamic Type Enabled", .dynamicType),
//        ("Delayed", .delayed),
//        ("Thirty Options", .thirtyOptions),
//    ]
//    let cellIdentifier = "BaseCell"
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        tableView.delegate = self
//        tableView.dataSource = self
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
//    }
//
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//
//        view.backgroundColor = self.view.backgroundColor
//        tableView.frame = view.frame
//        tableView.frame.origin.y = 0.0
//        view.addSubview(tableView)
//    }
//
//    func showActionSheet(_ type: ActionSheetExampleType) {
//        var actionSheet: GTUIActionSheetController
//        switch type {
//        case .system:
//            actionSheet = ActionSheetSwiftExample.typical()
//            break;
//        case .typical:
//            actionSheet = ActionSheetSwiftExample.typical()
//        case .title:
//            actionSheet = ActionSheetSwiftExample.title()
//        case .message:
//            actionSheet = ActionSheetSwiftExample.message()
//        case .noIcons:
//            actionSheet = ActionSheetSwiftExample.noIcons()
//        case .titleAndMessage:
//            actionSheet = ActionSheetSwiftExample.titleAndMessage()
//        case .dynamicType:
//            actionSheet = ActionSheetSwiftExample.dynamic()
//        case .delayed:
//            actionSheet = ActionSheetSwiftExample.titleAndMessage()
//            let action = GTUIActionSheetAction(title: "Home", image: UIImage(named: "Home"), type:.default) { _ in
//                print("Second home action")
//            }
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//                actionSheet.title = "New title"
//                actionSheet.message = "New Message"
//                actionSheet.addAction(action)
//                actionSheet.addAction(action)
//                actionSheet.addAction(action)
//                actionSheet.backgroundColor = .green
//            }
//        case .thirtyOptions:
//            actionSheet = ActionSheetSwiftExample.thirtyOptions()
//        }
//        present(actionSheet, animated: true, completion: nil)
//    }
//}
//
//// MARK: Catalog by Convensions
//extension ActionSheetSwiftExample {
//
//    @objc class func catalogMetadata() -> [String: Any] {
//        return [
//            "breadcrumbs": ["Action Sheet", "Action Sheet (Swift)"],
//            "primaryDemo": false,
//            "presentable": true,
//        ]
//    }
//
//}
//
//extension ActionSheetSwiftExample : UITableViewDelegate {
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        showActionSheet(data[indexPath.row].type)
//    }
//}
//
//extension ActionSheetSwiftExample : UITableViewDataSource {
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
//        cell.textLabel?.text = data[indexPath.row].label
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return data.count
//    }
//}
//
//extension ActionSheetSwiftExample {
//    static var actionOne: GTUIActionSheetAction {
//        return GTUIActionSheetAction(title: "Home",
//                                     image: UIImage(named: "Home")!, type: .default) { (_) in
//                                        print("Home action") }
//
//    }
//
//    static var actionTwo: GTUIActionSheetAction {
//        return GTUIActionSheetAction(title: "Favorite",
//                                     image: UIImage(named: "Favorite")!, type: .default) { (_) in
//                                        print("Favorite action") }
//    }
//
//    static var actionThree: GTUIActionSheetAction {
//        return GTUIActionSheetAction(title: "Cancel",
//                                     image: UIImage(named: "Email")!, type: .cancel) { (_) in
//                                        print("Email action") }
//    }
//
//    static var messageString: String {
//        return "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur ultricies diam " +
//            "libero, eget porta arcu feugiat sit amet. Maecenas placerat felis sed risusnmaximus tempus. " +
//            "Integer feugiat, augue in pellentesque dictum, justo erat ultricies leo, quis eleifend nisi " +
//        "eros dictum mi. In finibus vulputate eros, in luctus diam auctor in."
//    }
//
//    static func typical() -> GTUIActionSheetController {
//        let actionSheet = GTUIActionSheetController()
//        actionSheet.addAction(actionOne)
//        actionSheet.addAction(actionTwo)
//        actionSheet.addAction(actionThree)
//        return actionSheet
//    }
//
//    static func title() -> GTUIActionSheetController {
//        let actionSheet: GTUIActionSheetController = GTUIActionSheetController(title: "Action Sheet")
//        actionSheet.addAction(actionOne)
//        actionSheet.addAction(actionTwo)
//        actionSheet.addAction(actionThree)
//        return actionSheet
//    }
//
//    static func message() -> GTUIActionSheetController {
//        let actionSheet = GTUIActionSheetController(title: nil,
//                                                   message: messageString)
//        actionSheet.addAction(actionOne)
//        actionSheet.addAction(actionTwo)
//        actionSheet.addAction(actionThree)
//        return actionSheet
//    }
//
//    static func titleAndMessage() -> GTUIActionSheetController {
//        let actionSheet = GTUIActionSheetController(title: "Action Sheet",
//                                                    message: messageString,
//                                                    type: .uiKit)
//
//        actionSheet.addAction(actionOne)
//        actionSheet.addAction(actionTwo)
//        actionSheet.addAction(actionThree)
//        return actionSheet
//    }
//
//    static func noIcons() -> GTUIActionSheetController {
//        let actionSheet = GTUIActionSheetController(title: "Action Sheet", message: messageString)
//        let action1 = GTUIActionSheetAction(title: "Home", image: nil, type: .default, handler: { _ in
//            print("Home action")
//        })
//        let action2 = GTUIActionSheetAction(title: "Favorite", image: nil, type: .default, handler: { _ in
//            print("Favorite action")
//        })
//        let action3 = GTUIActionSheetAction(title: "Email", image: nil, type: .default, handler: { _ in
//            print("Email action")
//        })
//        actionSheet.addAction(action1)
//        actionSheet.addAction(action2)
//        actionSheet.addAction(action3)
//        return actionSheet
//    }
//
//    static func dynamic() -> GTUIActionSheetController {
//        let actionSheet = GTUIActionSheetController(title: "Action sheet", message: messageString)
//        actionSheet.gtui_adjustsFontForContentSizeCategory = true
//        let actionThree = GTUIActionSheetAction(title: "Email",
//                                               image: UIImage(named: "Email")!,
//                                               type: .default,
//                                               handler: nil)
//        actionSheet.addAction(actionOne)
//        actionSheet.addAction(actionTwo)
//        actionSheet.addAction(actionThree)
//        return actionSheet
//    }
//
//    static func thirtyOptions() -> GTUIActionSheetController {
//        let actionSheet = GTUIActionSheetController(title: "Action sheet", message: messageString)
//        for i in 1...30 {
//            let action = GTUIActionSheetAction(title: "Action \(i)",
//                image: UIImage(named: "Home"),
//                type: .default,
//                handler: nil)
//            actionSheet.addAction(action)
//        }
//        actionSheet.addAction(actionThree)
//        return actionSheet
//    }
//
//}
//
