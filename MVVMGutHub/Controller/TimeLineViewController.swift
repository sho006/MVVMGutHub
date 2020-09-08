//
//  TimeLineViewController.swift
//  MVVMSample
//
//  Created by 石塚翔 on 2020/09/08.
//  Copyright © 2020 石塚翔. All rights reserved.
//

import UIKit
import SafariServices

final class TimeLineViewController: UIViewController{
    
    fileprivate var viewModel: UserListViewModel!
    @IBOutlet weak var tableView: UITableView!
    fileprivate var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TimeLineCell.self, forCellReuseIdentifier: "TimeLineCell")
        
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlValueDidChange(sender:)), for: .valueChanged)
        tableView.refreshControl = refreshControl
        
        
        viewModel = UserListViewModel()
        viewModel.stateDidUpdate = { [weak self] state in
            switch state {
            case .loading:
                self?.tableView.isUserInteractionEnabled = false
            case .finish:
                self?.tableView.isUserInteractionEnabled = true
                self?.tableView.reloadData()
                self?.refreshControl.endRefreshing()
            case .error(let error):
                self?.tableView.isUserInteractionEnabled = true
                self?.refreshControl.endRefreshing()
                
                let alertController = UIAlertController(title: error.localizedDescription, message: nil, preferredStyle: .alert)
                
                let alertAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(alertAction)
                self?.present(alertController,animated: true,completion: nil)
                
            }
        }
        
        viewModel.getUsers()
    }
    
    @objc func refreshControlValueDidChange(sender: UIRefreshControl) {
        viewModel.getUsers()
    }
}

extension TimeLineViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.usersCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let timeLineCell = tableView.dequeueReusableCell(withIdentifier: "TimeLineCell") as? TimeLineCell {
            let cellViewModel = viewModel.cellViewModels[indexPath.row]
            timeLineCell.setNickName(nickName: cellViewModel.nickName)
            cellViewModel.downloadImage { (progress) in
                switch progress {
                case .loading(let image):
                    timeLineCell.setIcon(icon: image)
                case .finish(let image):
                    timeLineCell.setIcon(icon: image)
                case .error:
                    break
                }
            }
            return timeLineCell
        }
        
        fatalError()
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellViewModel = viewModel.cellViewModels[indexPath.row]
        let webURL = cellViewModel.webURL
        let webViewController = SFSafariViewController(url: webURL)
        navigationController?.pushViewController(webViewController, animated: true)
    }

}
