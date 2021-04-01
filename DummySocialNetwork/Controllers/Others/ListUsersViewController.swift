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
    private let userId:String
    private var users = [User]()

     private let tableView:UITableView = {
        let tableView = UITableView()
        tableView.isHidden = true
        tableView.register(ListUsersTableViewCell.self,
                           forCellReuseIdentifier: ListUsersTableViewCell.identifier)
        return tableView
    }()
    
    private let noUserLabel:UILabel = {
        let label = UILabel()
        label.text = "No User Found"
        label.isHidden = true
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        return label
    }()
   
    
    init(vcTitle:String,isFollowing:Bool = false,userId:String) {
        self.vcTitle = vcTitle
        self.isFollowing = isFollowing
        self.userId = userId
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
        view.addSubview(noUserLabel)
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
        
        noUserLabel.frame = CGRect(x: 0,
                                    y: 0,
                                    width: view.width,
                                    height: 50)
        noUserLabel.center = view.center
    }
    
    private func configureUI() {
        if users.isEmpty {
            noUserLabel.isHidden = false
            tableView.isHidden = true
        } else {
            noUserLabel.isHidden = true
            tableView.isHidden = false
            tableView.reloadData()
        }
        
    }
    
    private func fetchData() {
        
        if isFollowing {
            ApiManager.shared.getFollowings(with: userId) { [weak self] result in
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
            ApiManager.shared.getFollowers(with: userId) { [weak self] result in
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
        let user = users[indexPath.row]
        let vc = ProfileViewController(user: user)
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
