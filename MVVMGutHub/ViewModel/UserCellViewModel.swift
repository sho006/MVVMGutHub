//
//  UserCellViewModel.swift
//  MVMMSample
//
//  Created by 石塚翔 on 2020/09/08.
//  Copyright © 2020 石塚翔. All rights reserved.
//

import UIKit

// 現在ダウンロード中か、ダウンロード終了か、エラーかの状態を定義
enum ImageDownLoadProgress {
    case loading(UIImage)
    case finish(UIImage)
    case error
}

class UserCellViewModel {
    
    private var user: User
    
    private let imgeDownloader = ImgeDownloader()
    
    private var isLoading = false
    
    init(user: User) {
        self.user = user
    }
    
    var nickName: String {
        return user.name
    }
    
    var webURL: URL {
        return URL(string: user.webURL)!
    }
    
    
    func downloadImage(progress :@escaping (ImageDownLoadProgress) -> Void) {
        
        if isLoading {
            return
        }
        
        isLoading = true
        
        let loadingIamge = UIImage(color: .gray, size: CGSize(width: 45, height: 45))!
        
        progress(.loading(loadingIamge))
        
        imgeDownloader.downloadImage(imageURL: user.iconUrl, success: { (image) in
            progress(.finish(image))
            self.isLoading = false
        }) { (error) in
            progress(.error)
            self.isLoading = false
        }
        
    }
}

extension UIImage {
    convenience init?(color: UIColor, size: CGSize) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else {
            return nil
        }
        self.init(cgImage: cgImage)
    }
}
