//
//  Category.swift
//  WeiXinTouTiao
//
//  Created by KaFeiDou on 2017/9/25.
//  Copyright © 2017年 KaFeiDou. All rights reserved.
//

import Foundation
import ObjectMapper
import Moya

// ObjectMapper 的 Mappable 有兩個 protocol，`init`、`mapping`，必須遵從
// 在，我的 localhost 中的 api/get_category_index/，另外有，status、count、categories，這裡也是需要列出來的
struct CategoryInResponse: Mappable {
    
    var status: String!
    var count:Int!
    var categories:[Category]!
    
    // init map 為空
    init?(map: Map) {
        
    }
    // 解析 JSON，把右邊 JSON 屬性，導到右邊自己的屬性
    mutating func mapping(map: Map) {
        status <- map["status"]
        count <- map["count"]
        categories <- map["categories"]
    }
}

// 一個分類的類別，裡面有 id & title & count
struct Category:Mappable {
    
    var id:Int!
    var title:String!
    var count:Int!
    
    // init map 為空
    init?(map: Map) {
        
    }
    
    // 解析 JSON，把右邊 JSON 屬性，導到右邊自己的屬性
    mutating func mapping(map: Map) {
        id <- map["id"]
        title <- map["title"]
        count <- map["post_count"]
    }
}

extension Category {
  
    // 獲取一個分類，記得在 info.plist 一定要新增`App Transport Security Settings`
    static func request (completionHandler: @escaping ([Category]?) -> Void) {
        
        let provider = MoyaProvider<NetworkService>()
        provider.request(.category) { (results) in
            switch results {
            case let .success(MoyaResponse):
                let json = try! MoyaResponse.mapJSON() as! [String:Any]
                if let jsonResponse = CategoryInResponse(JSON: json) {
                    
                    completionHandler(jsonResponse.categories)
                    
                }
            case .failure:
                print("網路錯誤")
                completionHandler(nil)
                
            }
        }
    }
}

/*
 {
 "status": "ok",
 "count": 1,
 "categories": [
 {
 "id": 2,
 "slug": "hot",
 "title": "\u71b1\u9ede",
 "description": "",
 "parent": 0,
 "post_count": 1
 }
 ]
 }
 */
