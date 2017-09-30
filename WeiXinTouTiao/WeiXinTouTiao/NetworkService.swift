//
//  NetworkService.swift
//  WeiXinTouTiao
//
//  Created by KaFeiDou on 2017/9/25.
//  Copyright © 2017年 KaFeiDou. All rights reserved.
//

import Foundation
import Moya

enum NetworkService {
    case category
    case showCatesNewsList(id: Int)
    case submitComment(postId:Int, name:String, email:String, content:String)
}

// MARK: - TargetType Protocol Implementation
extension NetworkService: TargetType {
    
    // base API
    var baseURL: URL {
        let baseUrl = "http://localhost:8888/wordpress/api"
        return URL(string: baseUrl)!
    }
    
    // 入徑
    var path: String {
        switch self {
        case .category:
            return "/get_category_index"
        case .showCatesNewsList:
            return "/get_category_posts"
        case .submitComment:
            return "/respond/submit_comment"
        }
    }
    
    // 方法
    var method: Moya.Method {
        switch self {
        case .category:
            return .get
        case .showCatesNewsList:
            return .get
        case .submitComment:
            return .get
        }
    }
    
    // 參數
    var parameters: [String : Any]? {
        switch self {
        case .category:
            return nil
        case .showCatesNewsList(let id):
            return ["id":id]
        case .submitComment(let postId, let name, let email, let content):
            return ["post_id":postId, "name": name, "email":email,"content":content]
        }
    }
    
    // 參數的編碼，默認的編碼
    var parameterEncoding: ParameterEncoding {
        switch self {
        case .category:
            return URLEncoding.default
        case .showCatesNewsList:
            return URLEncoding.default
        case .submitComment:
            return URLEncoding.default
        }
    }
    
    // 單元測試
    var sampleData: Data {
        switch self {
        case .category:
            return "category test data".utf8Encoded
        case .showCatesNewsList(let id):
            return "news list id is \(id)".utf8Encoded
        case .submitComment(let postId, let name, let email, let content):
            return "submit comment is \(postId),\(name),\(email),\(content)".utf8Encoded
        }
    }
    
    // 任務
    var task: Task {
        switch self {
        case .category:
            return .request
        case .showCatesNewsList:
            return .request
        case .submitComment:
            return .request
        }
    }
}

// MARK: - Helper for Encoding
private extension String {
    var urlEscaped: String {
        return addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
    var utf8Encoded: Data {
        return data(using: .utf8)!
    }
}

// 有更新數據的，使用 .post
// 沒有更新數據、參數的，使用 .get
