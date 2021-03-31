//
//  HomeViewController.swift
//  DummySocialNetwork
//
//  Created by Shivam Rishi on 27/03/21.
//

import UIKit

final class HomeViewController: UIViewController {

    private var posts = [Post]()

    private let noPostsLabel:UILabel = {
        let label = UILabel()
        label.text = "No Posts"
        label.isHidden = true
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        return label
    }()
    
    private let tableView:UITableView = {
        let tableView = UITableView()
        tableView.isHidden = true
        tableView.register(PostTableViewCell.self,
                           forCellReuseIdentifier: PostTableViewCell.identifier)
        return tableView
    }()
    
    private let refreshControl:UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        return refreshControl
    }()
    

    private var observer:NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Home"
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        view.addSubview(noPostsLabel)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        fetchMyPosts()
        
        observer = NotificationCenter.default.addObserver(
            forName: .didNotifyProfileUpdate,
            object: nil,
            queue: .main,
            using: { [weak self] _ in
                self?.fetchMyPosts()
            })
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"),
                            style: .plain,
                            target: self,
                            action: #selector(didTapPost))
        ]

    }
    
    @objc private func didPullToRefresh() {
        DispatchQueue.main.async { [weak self] in
            self?.refreshControl.endRefreshing()
        }
    }
    
    @objc private func didTapPost() {
        let vc = CreatePostViewController()
        vc.createPostCompletion = { [weak self] success in
            DispatchQueue.main.async {
                if success {
                    self?.fetchMyPosts()
                }
            }
        }
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .fullScreen
        navVC.navigationBar.tintColor = .label
        present(navVC, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        
        noPostsLabel.frame = CGRect(x: 0,
                                    y: 0,
                                    width: view.width,
                                    height: 50)
        noPostsLabel.center = view.center
       
    }

    private func fetchMyPosts() {
        ApiManager.shared.getMyPosts { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let posts):
                    self?.posts = posts
                    self?.configureUI()
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    private func configureUI() {
        NotificationCenter.default.post(name: .didNotifyPostCount,
                                        object: nil,
                                        userInfo: nil)
        if posts.isEmpty {
            noPostsLabel.isHidden = false
            tableView.isHidden = true
        } else {
            noPostsLabel.isHidden = true
            tableView.isHidden = false
            tableView.reloadData()
        }
    }
    
    
}

extension HomeViewController:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.identifier,
                                                       for: indexPath) as? PostTableViewCell else {
            return UITableViewCell()
        }
        let model = posts[indexPath.row]
        let viewModel = PostViewModel(content: model.content,
                                      name: model.name,
                                      profilePictureUrl: URL(string: model.profilePictureUrl ?? ""),
                                      createdDate: String.formattedDate(
                                        string: model.createdDate,
                                        dateFormat: "MMM d, h:mm a"))
        cell.configure(with: viewModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            tableView.beginUpdates()
            let postId = posts[indexPath.row]._id
            let deletedPost = posts.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath],
                                 with: .left)
            ApiManager.shared.deletePost(with: postId) { [weak self] success in
                DispatchQueue.main.async {
                    if !success {
                        // add model and row back and show error alert
                        self?.posts.insert(deletedPost, at: indexPath.row)
                        tableView.insertRows(at: [indexPath],
                                             with: .left)
                    }
                    self?.configureUI()
                }
            }
            tableView.endUpdates()
        }
    }
}

