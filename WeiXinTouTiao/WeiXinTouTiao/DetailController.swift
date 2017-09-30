//
//  DetailController.swift
//  WeiXinTouTiao
//
//  Created by KaFeiDou on 2017/9/27.
//  Copyright © 2017年 KaFeiDou. All rights reserved.
//

import UIKit
import WebKit
import LeoDanmakuKit
import LLSwitch
import WZLBadge

class DetailController: UIViewController, LLSwitchDelegate {
    
    var webView:WKWebView!
    //var url:URL!
    //var content:String!
    var post:Post!
    var danmuOn = true
    
    @IBOutlet weak var danmuView: LeoDanmakuView!
    @IBOutlet weak var danmuSwitch: LLSwitch!
    @IBOutlet weak var commentbadge: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadHtml()
        loadDanmu(comments: post.comments)
        
        title = post.title
        
        // 要把 LLSwitch 代理，設定噢
        danmuSwitch.delegate = self
        
        showCommentBadge(post.comment_count)
    }
    
    func loadHtml() {
        // 狀態條，高度是 20，導航條，高度是 44，這是固定的
        let frame = CGRect(x: 0, y: 20, width: self.view.frame.width, height: self.view.frame.height - 45)
        webView = WKWebView(frame: frame)
        
        // 將 webView，插入 view 的最底層，最底層為 0
        view.insertSubview(webView, at: 0)
        
        // load 主要是傳遞方式為：url 網址，這會將我們預設前台的網頁，一起載入
        //webView.load(URLRequest(url: url))
        
        // 從網頁傳進來的網頁並不是一個完整的 html 各式，
        // 所以必須補全，因為網頁和移動端的 viewport 不一樣
        var header = "<html>"
        header += "<head>"
        header += "<meta name=\"viewport\" content=\"width=device-width; initial-scale=1.0\">"
        
        header += "<style>"
        header += " img { width: 100% } body { font-size: 100%; background: white }"
        header += "</style>"
        
        
        
        // 按 commentBadge 的時候，會直接跳到該指定的頁面位置 (這是 jQuery 語法) -> 這是 js2 使用
        //header += "<script src=\"https://cdn.bootcss.com/jquery/3.2.1/jquery.min.js\"> </script>"
        
        // 按 commentBadge 的時候，會直接跳到該指定的頁面位置 (這是將新增一個文本，將文本發佈在 localhost 的文章中，並取得網址位置)
         header += "<script src=\"http://localhost:8888/wordpress/wp-content/uploads/2017/10/Scroll.js\"> </script>"
        
        
        header += "</head>"
        header += "<body>"
        
        // 使用 id="commentAnchor" 來當一個位置，當點擊 btnComment
        let comment = "<hr size=4, id=\"commentAnchor\">" + commentHtml(comments: post.comments)
        
        var footer = "</body>"
        footer += "</html>"
        
        // loadHTMLString 主要是傳遞方式為：content 內容
        webView.loadHTMLString(header + post.content + comment + footer, baseURL: nil)
    }
    
    // 將所有的評論加到每一篇的文章最底下
    func commentHtml(comments:[Comments]) -> String {
        var result = ""
        
        for comment in comments {
            let paragraph = "<p>  <h5> \(comment.name!) </h5> <h3> \(comment.content!) </h3> <hr size=1>  </p>"
            result += paragraph
        }
        return result
    }
    
    // 執行 JavaScript 的方法
    func doJavaScriptFunction() {
        
        //let js1 = "$(\"p\").hide()"
        
        // 跳轉到指定的 id 位置 (直接跳到該指定的位置)
        let js2 = "window.location.hash = \"commentAnchor\""
        
        // 跳轉到指定的 id 位置 (滑動到該指定的位置)
        let js3 = "ScrollToControl(\'commentAnchor\')"
        
        webView.evaluateJavaScript(js3) { (results, error) in
            print("js3的結果：",results,error)
        }
    }
    
    // 把執行 JavaScript 的方法置入按鈕當中
    @IBAction func btnComment(_ sender:UIButton) {
        print("點擊了評論，顯示評論按鈕")
        doJavaScriptFunction()
    }
    
    
    // 設定彈幕，兩種，一種：評論式；一種：評語式
    func loadDanmu(comments:[Comments]? = nil, postAcomment:String? = nil) {
        
        if danmuOn {
            danmuView.resume()
            
            // 第一種顯示 danmu，評論
            if let comments = comments {
                let danmus:[LeoDanmakuModel] = comments.map {
                    let model = LeoDanmakuModel.randomDanmku(withColors: UIColor.danmu, maxFontSize: 30, minFontSize: 15)
                    model?.text = $0.content.html2String
                    return model!
                }
                danmuView.addDanmaku(with: danmus)
            }
            // 第二種顯示 danmu，評語
            if let comment = postAcomment {
                let model = LeoDanmakuModel.randomDanmku(withColors: UIColor.danmu, maxFontSize: 30, minFontSize: 15)
                model?.text = comment
                danmuView.addDanmaku(model)
            }
        } else {
            danmuView.stop()
        }
    }
    
    // 設置 danmu 的開關
    func didTap(_ llSwitch: LLSwitch!) {
        if danmuOn {
            danmuSwitch.setOn(false, animated: true)
            danmuView.stop()
            danmuView.isHidden = true
            print("danmu is OFF")
        } else {
            danmuSwitch.setOn(true, animated: true)
            danmuView.resume()
            danmuView.isHidden = false
            print("danmu is ON")
        }
        danmuOn = !danmuOn
    }
    
    // 把 badge，顯示在 commentBadge 上面
    func showCommentBadge(_ count: Int) {
        if count > 0 {
            commentbadge.badgeCenterOffset = CGPoint(x: -4, y: 5)
            commentbadge.showBadge(with: .number, value: count, animationType: .bounce)
        }
    }
    
    // 先將 UITextField 直接拖 delegate 到 view 上面，然後直接下發生事件的 action，因為要設定些有關 danmu 的
    @IBAction func editBegin(_ sender: UITextField) {
        
        commentbadge.isHidden = true
        danmuView.isHidden = true
    }
    
    @IBAction func editDone(_ sender: UITextField) {
        
        commentbadge.isHidden = false
        danmuView.isHidden = false
        
        guard let commentText = sender.text else { return }
        loadDanmu(postAcomment: commentText)
        print("發表評論")
        
        Post.submitComment(postId: post.id, name: "KaFei", email: "kafeidou0909@gmail.com", content: commentText) { (finish) in
            if finish {
                print("評論成功")
                
                OperationQueue.main.addOperation {
                    self.showCommentBadge(self.post.comment_count + 1)
                    
                    // 通知 NewsListController 的版，自動更新，不應該是使用者去下刷更新才更新
                    NotificationCenter.default.post(name: NotificationHelper.updateList, object: nil)
                }
            }
        }
        // 發佈評論成功以後，清空文本框
        sender.text = ""
    }
}
