//
//  NewsListController.swift
//  WeiXinTouTiao
//
//  Created by KaFeiDou on 2017/9/25.
//  Copyright © 2017年 KaFeiDou. All rights reserved.
//

import UIKit

class NewsListController: UITableViewController {
    
    var newsList:[Post] = []
    
    var id = 0
    
    // 一般來說，一個 storyboard 只需要一個 navigationController，這裡的 newsListController 並沒有使用 segue 的方式，
    // 所以，可以使用`繼承`的方法來做
    var parentNavigation: UINavigationController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getData()
        
        // NewsList 的下拉刷新資料
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(getData), for: .valueChanged)
        
        // 添加一個通知觀察器，如果有 name 的通知，我就執行 selector 的方法
        NotificationCenter.default.addObserver(self, selector: #selector(getData), name: NotificationHelper.updateList, object: nil)
        
        // tableView 的高讀，隨著傳入的內容自動變更
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TextCell", for: indexPath) as! TextCell
        
        let news = newsList[indexPath.row]
        cell.lblTitle.text = news.title
        cell.lblComment.text = "評論：\(news.comment_count!)"
        
        return cell
    }
    
    func getData() {
        
        // 用穿進來的 id 來撈資料
        Post.request(id: id) { (posts) in
            if let posts = posts {
                OperationQueue.main.addOperation {
                    self.newsList = posts
                    self.tableView.reloadData()
                    self.refreshControl?.endRefreshing()
                }
            } else {
                print("網路錯誤")
            }
        }
    }
    
    // 實例化 DetailController
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = storyboard?.instantiateViewController(withIdentifier: "SBID_NEWDETAIL") as! DetailController
        
        let news = newsList[tableView.indexPathForSelectedRow!.row]
        
        detailVC.post = news
        
        //detailVC.title = news.title
        //detailVC.url = URL(string: news.url)
        //detailVC.content = news.content
        
        parentNavigation?.pushViewController(detailVC, animated: true)
    }
}

