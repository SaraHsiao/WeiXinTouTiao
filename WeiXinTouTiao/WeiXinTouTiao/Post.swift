//
//  Post.swift
//  WeiXinTouTiao
//
//  Created by KaFeiDou on 2017/9/27.
//  Copyright © 2017年 KaFeiDou. All rights reserved.
//

import Foundation
import ObjectMapper
import Moya

// ObjectMapper 的 Mappable 有兩個 protocol，`init`、`mapping`，必須遵從
// 在，我的 localhost 中的 api/get_category_index/，另外有，status、count、categories，這裡也是需要列出來的
struct PostInResponse: Mappable {
    
    var status: String!
    var count:Int!
    var posts:[Post]!
    
    // init map 為空
    init?(map: Map) {
        
    }
    // 解析 JSON，把右邊 JSON 屬性，導到右邊自己的屬性
    mutating func mapping(map: Map) {
        status <- map["status"]
        count <- map["count"]
        posts <- map["posts"]
    }
}

// 提交的回應，只需要 status，status 如果是 OK，就代表提交成功
struct SubmitResponse:Mappable {
    
    var status: String!
    
    init?(map: Map) {
    
    }
    
    mutating func mapping(map: Map) {
        status <- map["status"]
    }
}

// 評論的時候，需要，名字 & 評論內容
struct Comments:Mappable {
    var name:String!
    var content:String!
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        name <- map["name"]
        content <- map["content"]
    }
}

struct Post:Mappable {
    
    var id:Int!
    var title:String!
    var content:String!
    var url:String!
    var comment_count:Int!
    var comments:[Comments]!
    
    // init map 為空
    init?(map: Map) {
        
    }
    
    // 解析 JSON，把右邊 JSON 屬性，導到右邊自己的屬性
    mutating func mapping(map: Map) {
        id <- map["id"]
        title <- map["title"]
        content <- map["content"]
        url <- map["url"]
        comment_count <- map["comment_count"]
        comments <- map["comments"]
    }
}

extension Post {
    
    // 獲取一個分類，記得在 info.plist 一定要新增`App Transport Security Settings`
    // 獲取分類下面列表的文章
    static func request (id: Int, completionHandler: @escaping ([Post]?) -> Void) {
        
        let provider = MoyaProvider<NetworkService>()
        provider.request(.showCatesNewsList(id: id)) { (results) in
            switch results {
            case let .success(MoyaResponse):
                let json = try! MoyaResponse.mapJSON() as! [String:Any]
                if let jsonResponse = PostInResponse(JSON: json) {
                    
                    completionHandler(jsonResponse.posts!)
                }
            case .failure:
                print("網路錯誤")
                completionHandler(nil)
            }
        }
    }
    
    // 提交評論，只有，true 和 false，所以 SubmitResponse 只需要 status，true 代表提交評論成功
    static func submitComment(postId:Int, name:String, email:String, content:String, completionHandler: @escaping (Bool) -> Void) {
        
        let provider = MoyaProvider<NetworkService>()
        provider.request(.submitComment(postId: postId, name: name, email: email, content: content)) { (results) in
            switch results {
            case let .success(MoyaResponse):
                let json = try! MoyaResponse.mapJSON() as! [String:Any]
                if let jsonResponse = SubmitResponse(JSON: json) {
                    if jsonResponse.status == "ok" {
                        completionHandler(true)
                    } else {
                        completionHandler(false)
                    }
                }
            case .failure:
                print("網路錯誤")
                completionHandler(false)
            }
        }
    }
}
