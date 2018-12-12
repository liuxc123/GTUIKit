//
//  TestListBaseViewController.swift
//  GTCatalog
//
//  Created by liuxc on 2018/12/12.
//

import UIKit
import GTUIKit

@objc public class TestListBaseView: UIView {
    @objc public var tableView: UITableView!
    @objc public var dataSource: [String]?
    @objc public var isNeedHeader = false
    @objc public var isNeedFooter = false
    var listViewDidScrollCallback: ((UIScrollView) -> ())?
    var lastSelectedIndexPath: IndexPath?

    deinit {
        listViewDidScrollCallback = nil
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        tableView = UITableView(frame: frame, style: .plain)
        tableView.backgroundColor = UIColor.white
        tableView.tableFooterView = UIView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TestTableViewCell.classForCoder(), forCellReuseIdentifier: "cell")
        addSubview(tableView)
    }

    @objc func headerRefresh() {
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.seconds(2)) {
//            self.tableView.mj_header.endRefreshing()
//        }
    }

    override public func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)

//        if newSuperview != nil {
//            if isNeedHeader {
//                self.tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(headerRefresh))
//            }
//            if isNeedFooter {
//                tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(loadMore))
//            }
//        }
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func layoutSubviews() {
        super.layoutSubviews()

        tableView.frame = self.bounds
    }

    @objc func loadMore() {
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.seconds(2)) {
//            self.dataSource?.append("加载更多成功")
//            self.tableView.reloadData()
//            self.tableView.mj_footer.endRefreshing()
//        }
    }

    func selectedCell(at indexPath: IndexPath) {
        if lastSelectedIndexPath == indexPath {
            return
        }
        if lastSelectedIndexPath != nil {
            let cell = tableView.cellForRow(at: lastSelectedIndexPath!)
            cell?.setSelected(false, animated: false)
        }
        let cell = tableView.cellForRow(at: indexPath)
        cell?.setSelected(true, animated: false)
        lastSelectedIndexPath = indexPath
    }

}

extension TestListBaseView: UITableViewDataSource, UITableViewDelegate {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource?.count ?? 0
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TestTableViewCell
        cell.textLabel?.text = dataSource?[indexPath.row]
        cell.bgButtonClicked = {[weak self] in
            print("bgButtonClicked:\(indexPath)")
            self?.selectedCell(at: indexPath)
        }
        return cell
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.listViewDidScrollCallback?(scrollView)
    }
}

extension TestListBaseView: GTUIPageViewListViewDelegate {

    public func listView() -> UIView! {
        return self
    }

    public func listScrollView() -> UIScrollView! {
        return self.tableView
    }

    public func listViewDidScrollCallback(_ callback: ((UIScrollView?) -> Void)!) {
        self.listViewDidScrollCallback = callback
    }
}
