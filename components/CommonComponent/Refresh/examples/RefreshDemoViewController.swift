//
//  RefreshDemoViewController.swift
//  GTCatalog
//
//  Created by liuxc on 2018/12/13.
//

import UIKit
import GTUIKit

class RefreshDemoViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
         self.clearsSelectionOnViewWillAppear = false

        self.title = "下拉刷新，上拉加载"
        self.view.backgroundColor = UIColor.white

        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
        self.tableView.tableFooterView = UIView()

//        self.tableView.setRefreshWithHeaderBlock {
//            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: {
//                self.tableView.endRefreshing(false)
//            })
//        }
//
        self.tableView.setRefreshWithFooterBlock {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: {
                self.tableView.endRefreshing(false)
            })
        }

        self.tableView.setRefreshWith(.normal, headerBlock: {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: {
                self.tableView.endRefreshing(false)
            })
        }, footerType: .backNormal) {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: {
                self.tableView.endRefreshing(false)
            })
        }

        self.tableView.headerBeginRefreshing()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        cell.textLabel?.text = "title\(indexPath.row)"
        return cell
    }


}

extension RefreshDemoViewController {
    @objc class func catalogMetadata() -> [String: Any] {
        return [
            "breadcrumbs": ["Refresh"],
            "primaryDemo": true,
            "presentable": true
        ]
    }
}
