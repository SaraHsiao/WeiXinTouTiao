//
//  Html2String.swift
//  WeiXinTouTiao
//
//  Created by KaFeiDou on 2017/9/29.
//  Copyright © 2017年 KaFeiDou. All rights reserved.
//

import Foundation

// 解決 danmu 跑文字的時候出現一些 html 的語法和亂碼問題，
// 將 html 的格式轉換成文本類型

// attributed 有裝飾的、有格式的文本
extension String {
    
    var html2AttributedString: NSAttributedString? {
        
        do {
            
            // 把 html 的文本，轉成 attributed 屬性
            return try NSAttributedString(data: Data(utf8), options: [
                NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType,
                NSCharacterEncodingDocumentAttribute:String.Encoding.utf8.rawValue
                ], documentAttributes: nil)
            
        } catch {
            print(error)
            return nil
        }
    }
    
    // 計算屬性
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
}
