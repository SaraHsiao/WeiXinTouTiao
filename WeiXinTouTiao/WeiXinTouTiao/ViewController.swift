//
//  ViewController.swift
//  WeiXinTouTiao
//
//  Created by KaFeiDou on 2017/9/25.
//  Copyright © 2017年 KaFeiDou. All rights reserved.
//

import UIKit
import Moya
import PageMenu

class ViewController: UIViewController {
    
    var pageMenu:CAPSPageMenu!
    var controllers:[UIViewController] = [ ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 將返回按鈕的文字去掉，只保留箭頭 (代碼必須寫在連 navigaionController 上面的)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        showMenu()
    }
    
    func showMenu() {
        
        Category.request { (cates) in
            
            self.controllers = cates!.map {
                
                // 實例化 NewsListController
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "SBID_NEWSLIST") as! NewsListController
                vc.title = $0.title
                
                // 將自己本身擁有的 navigationController 傳遞到 newListController 過去
                vc.parentNavigation = self.navigationController
                
                vc.id = $0.id
                
                return vc
            }
            
            // 設定滑動菜單的選項（樣式）
            let parameters: [CAPSPageMenuOption] = [
                .menuItemSeparatorWidth(2),
                .scrollMenuBackgroundColor(UIColor.black),
                .viewBackgroundColor(UIColor(red: 247.0/255.0, green: 247.0/255.0, blue: 247.0/255.0, alpha: 1.0)),
                .bottomMenuHairlineColor(UIColor.green),
                .selectionIndicatorColor(UIColor.orange),
                .selectionIndicatorHeight(5.0),
                .menuMargin(15.0),
                .menuHeight(60.0),
                .selectedMenuItemLabelColor(UIColor.white),
                .unselectedMenuItemLabelColor(UIColor.lightGray),
                .menuItemFont(UIFont(name: "HelveticaNeue-Medium", size: 20)!),
                .useMenuLikeSegmentedControl(false),
                .menuItemSeparatorRoundEdges(true),
                .menuItemSeparatorPercentageHeight(0.0)
            ]
            
            // 菜單的大小和位置 // NavigationBar 固定高度為 44
            let frame = CGRect(x: 0, y: 20 + 44, width: self.view.frame.width, height: self.view.frame.height - 20 - 44)
            self.pageMenu = CAPSPageMenu(viewControllers: self.controllers, frame: frame, pageMenuOptions: parameters)
            
            self.view.addSubview(self.pageMenu!.view)
        }
    }
}
