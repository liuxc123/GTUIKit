//
//  UIPageViewController.swift
//  GTCatalog
//
//  Created by liuxc on 2018/12/12.
//

import UIKit
import GTUIKit

let GTTableHeightViewHeight: CGFloat = 200;
let GTHeightForHeaderInSection: CGFloat = 50;

class UIPageViewController: UIViewController, GTUIPageViewDelegate {

    lazy var pageView: GTUIPageListRefreshView = { [unowned self] in
        let pageView = GTUIPageListRefreshView(delegate: self)
        return pageView!;
    }()

    lazy var tabBarView: GTUITabBarTitleView = {
        let tabBarView = GTUITabBarTitleView()
        tabBarView.titles = ["能力", "爱好", "队友"]
        tabBarView.backgroundColor = UIColor.white
        let line = GTUITabBarIndicatorLineView()
        line.indicatorLineWidth = 30;
        line.indicatorLineViewColor = UIColor.black
        tabBarView.indicators = [line]
        return tabBarView
    }()

    var listViewArray = [GTUIPageViewListViewDelegate]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "PageView"
        self.view.backgroundColor = UIColor.white

        self.listViewArray = preferredListViewsArray()

        self.view.addSubview(self.pageView);

        self.tabBarView.contentScrollView = self.pageView.listContainerView.collectionView

        

    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.pageView.frame = CGRect(x: 0, y: 100, width: self.view.bounds.size.width, height: self.view.bounds.size.height - 100)
    }



    func preferredListViewsArray() -> [GTUIPageViewListViewDelegate] {
        let powerListView = TestListBaseView()
        powerListView.dataSource = ["橡胶火箭", "橡胶火箭炮", "橡胶机关枪", "橡胶子弹", "橡胶攻城炮", "橡胶象枪", "橡胶象枪乱打", "橡胶灰熊铳", "橡胶雷神象枪", "橡胶猿王枪", "橡胶犀·榴弹炮", "橡胶大蛇炮", "橡胶火箭", "橡胶火箭炮", "橡胶机关枪", "橡胶子弹", "橡胶攻城炮", "橡胶象枪", "橡胶象枪乱打", "橡胶灰熊铳", "橡胶雷神象枪", "橡胶猿王枪", "橡胶犀·榴弹炮", "橡胶大蛇炮"]

        powerListView.tableView.setRefreshWith(.normal, headerBlock: {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: {
                powerListView.tableView.endRefreshing(false)
            })
        }, footerType: .backNormal) {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: {
                powerListView.tableView.endRefreshing(false)
            })
        }

        let hobbyListView = TestListBaseView()
        hobbyListView.dataSource = ["吃烤肉", "吃鸡腿肉", "吃牛肉", "各种肉"]

        hobbyListView.tableView.setRefreshWith(.normal, headerBlock: {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: {
                hobbyListView.tableView.endRefreshing(false)
            })
        }, footerType: .backNormal) {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: {
                hobbyListView.tableView.endRefreshing(false)
            })
        }

        let partnerListView = TestListBaseView()
        partnerListView.dataSource = ["【剑士】罗罗诺亚·索隆", "【航海士】娜美", "【狙击手】乌索普", "【厨师】香吉士", "【船医】托尼托尼·乔巴", "【船匠】 弗兰奇", "【音乐家】布鲁克", "【考古学家】妮可·罗宾"]

        partnerListView.tableView.setRefreshWith(.normal, headerBlock: {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: {
                partnerListView.tableView.endRefreshing(false)
            })
        }, footerType: .backNormal) {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: {
                partnerListView.tableView.endRefreshing(false)
            })
        }

        return [powerListView, hobbyListView, partnerListView]
    }

    func tableHeaderView(inPagerView pagerView: GTUIPageView!) -> UIView! {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.width(), height: 200))
        headerView.backgroundColor = UIColor.red
        return headerView
    }

    func tableHeaderViewHeight(inPagerView pagerView: GTUIPageView!) -> UInt {
        return UInt(GTTableHeightViewHeight);
    }

    func heightForPinSectionHeader(inPagerView pagerView: GTUIPageView!) -> UInt {
        return 50;
    }

    func viewForPinSectionHeader(inPagerView pagerView: GTUIPageView!) -> UIView! {
        return self.tabBarView
    }

    func numberOfLists(inPagerView pagerView: GTUIPageView!) -> Int {
        return self.listViewArray.count
    }

    func pagerView(_ pagerView: GTUIPageView!, initListAt index: Int) -> GTUIPageViewListViewDelegate! {
        return self.listViewArray[index]
    }



}
extension UIPageViewController {
    @objc class func catalogMetadata() -> [String: Any] {
        return [
            "breadcrumbs": ["TabBar", "GTUIPageView"],
            "primaryDemo": true,
            "presentable": true
        ]
    }
}
