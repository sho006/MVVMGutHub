//
//  User.swift
//  MVMMSample
//
//  Created by 石塚翔 on 2020/09/08.
//  Copyright © 2020 石塚翔. All rights reserved.
//

import Foundation

final class User {
    let id: Int
    let name: String
    let iconUrl: String
    let webURL: String
    
    init(attributes: [String: Any]) {
        id = attributes["id"] as! Int
        name = attributes["login"] as! String
        iconUrl = attributes["avatar_url"] as! String
        webURL = attributes["html_url"] as! String
    }
}
