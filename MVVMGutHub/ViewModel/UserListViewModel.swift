//
//  UserListViewModel.swift
//  MVMMSample
//
//  Created by 石塚翔 on 2020/09/08.
//  Copyright © 2020 石塚翔. All rights reserved.
//

import UIKit

// 現在通信中か、通信が成功したのか、通信が失敗したのかの状態を定義
enum ViewModelState {
    case loading
    case finish
    case error(Error)
}

final class UserListViewModel {
    
    var stateDidUpdate: ((ViewModelState) -> Void)?
    
    private var users = [User]()
    
    var cellViewModels = [UserCellViewModel]()
    
    let api = API()
    
    func getUsers() {
        
        stateDidUpdate?(.loading)
        users.removeAll()
        
        api.getUsers(success: { (users) in
            self.users.append(contentsOf: users)
            for user in users {
                let cellViewModel = UserCellViewModel(user: user)
                self.cellViewModels.append(cellViewModel)
                
                self.stateDidUpdate?(.finish)
            }
        }) { (error) in
            
            self.stateDidUpdate?(.error(error))
        }
    }
    
    func usersCount() -> Int {
        return users.count
    }
}
