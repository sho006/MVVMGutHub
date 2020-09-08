//
//  ImgeDownloader.swift
//  MVMMSample
//
//  Created by 石塚翔 on 2020/09/08.
//  Copyright © 2020 石塚翔. All rights reserved.
//

import UIKit

final class ImgeDownloader {
    
    var cacheImage:UIImage?
    
    func downloadImage(
        imageURL: String,
        success: @escaping (UIImage) -> Void,
        failure: @escaping (Error) -> Void) {
                
        if let cacheImage = cacheImage {
            success(cacheImage)
        }
        
        var request = URLRequest(url: URL(string: imageURL)!)
        request.httpMethod = "GET"
        
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
            
            guard let imageFromData = UIImage(data: data) else {
                DispatchQueue.main.async {
                    failure(APIError.unowned)
                }
                return
            }
            
            DispatchQueue.main.async {
                success(imageFromData)
            }
            
            self.cacheImage = imageFromData
        }
        
        task.resume()
    }
}
