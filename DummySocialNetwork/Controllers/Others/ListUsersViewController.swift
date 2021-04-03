//
//  ListUsersViewController.swift
//  DummySocialNetwork
//
//  Created by Shivam Rishi on 01/04/21.
//

import UIKit

class ListUsersViewController: UIViewController {

    private let vcTitle:String
    private let isFollowing:Bool
    private let isPostLikes:Bool
    private let id:String
    private var users = [User]()

     private let tableView:UITableView = {
        let tableView = UITableView()
        tableView.isHidden = true
        tableView.register(ListUsersTableViewCell.self,
                           forCellReuseIdentifier: ListUsersTableViewCell.identifier)
        return tableView
    }()
    
    private let noDataFoundLabel:UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        return label
    }()
   
    
    init(vcTitle:String,
         isFollowing:Bool = false,
         isPostLikes:Bool = false,
         id:String) {
        self.vcTitle = vcTitle
        self.isFollowing = isFollowing
        self.isPostLikes = isPostLikes
        self.id = id
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = vcTitle
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        view.addSubview(noDataFoundLabel)
        tableView.delegate = self
        tableView.dataSource = self
        fetchData()
        
        NotificationCenter.default.addObserver(
            forName: .didNotifyFollowUnfollowUpdate,
            object: nil,
            queue: .main,
            using: { [weak self] _ in
                self?.fetchData()
            })
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        
        noDataFoundLabel.frame = CGRect(x: 0,
                                    y: 0,
                                    width: view.width,
                                    height: 50)
        noDataFoundLabel.center = view.center
    }
    
    private func configureUI() {
        if users.isEmpty {
            noDataFoundLabel.text = "No \(vcTitle)"
            noDataFoundLabel.isHidden = false
            tableView.isHidden = true
        } else {
            noDataFoundLabel.isHidden = true
            tableView.isHidden = false
        }
        tableView.reloadData()
        
    }
    
    private func fetchData() {
        users.removeAll()
        if isPostLikes {
            
            ApiManager.shared.getLikedUsers(with: id) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let users):
                        self?.users = users
                        self?.configureUI()
                    case .failure(let error):
                        print(error)
                    }
                }
            }
        } else {
            
            if isFollowing {
                ApiManager.shared.getFollowings(with: id) { [weak self] result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let users):
                            self?.users = users
                            self?.configureUI()
                        case .failure(let error):
                            print(error)
                        }
                    }
                }
            } else {
                ApiManager.shared.getFollowers(with: id) { [weak self] result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let users):
                            self?.users = users
                            self?.configureUI()
                        case .failure(let error):
                            print(error)
                        }
                    }
                }
            }
        }
        
    }
    
}

extension ListUsersViewController:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
                withIdentifier: ListUsersTableViewCell.identifier,
                for: indexPath) as? ListUsersTableViewCell else {
            return UITableViewCell()
        }
        let model = users[indexPath.row]
        let viewModel = ListUsersViewModel(
            name: model.name,
            profilePictureUrl: URL(string: model.profilePictureUrl ?? ""))
        cell.configure(with: viewModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let userId = UserDefaults.standard.value(forKey: "userId") as? String else {
            return
        }
        
        let user = users[indexPath.row]
        
        let loggedInUser = users[indexPath.row]._id == userId
        
        if loggedInUser {
            let vc = ProfileViewController(isOwner: true,user: user)
            navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = ProfileViewController(user: user)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}
