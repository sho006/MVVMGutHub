//
//  API.swift
//  MVMMSample
//
//  Created by 石塚翔 on 2020/09/08.
//  Copyright © 2020 石塚翔. All rights reserved.
//

import Foundation

enum APIError: Error, CustomStringConvertible {
    case unowned
    case invalidURL
    case invalidResponse
    
    var description: String {
        switch self {
        case .unowned:
           return "不明なエラーです"
        case .invalidURL:
            return "無効なURLです"
        case .invalidResponse:
            return "フォーマットが無効なレスポンスを受け取りました"
        }
    }
}


class API {
    
    func getUsers(success: @escaping ([User]) -> Void,
                  failure: @escaping (Error) -> Void) {
        
        let requestURL = URL(string: "https://api.github.com/users")
        
        guard let url = requestURL else {
            failure(APIError.invalidURL)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            // エラーの場合はエラーを返す。
            if let error = error {
                DispatchQueue.main.async {
                    failure(error)
                }
                return
            }
            
            // データがなかったら、unownedをClosureで返す
            guard let data = data else {
                DispatchQueue.main.async {
                    failure(APIError.unowned)
                }
                return
            }
            
            //　レスポンスのデータ型が不正だったら、invalidResponseをClosureで返す
            guard let jsonOptional = try? JSONSerialization.jsonObject(with: data, options: []),
                let json = jsonOptional as? [[String: Any]]
                else {
                    DispatchQueue.main.async {
                        failure(APIError.invalidResponse)
                    }
                    return
            }
            
            var users = [User]()
            
            for j in json {
                let user = User(attributes: j )
                users.append(user)
            }
            
            DispatchQueue.main.async {
                success(users)
            }
            
        }
        
        task.resume()
    }
}
