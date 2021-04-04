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
        fetchHomeFeed()
        
        observer = NotificationCenter.default.addObserver(
            forName: .didNotifyProfileUpdate,
            object: nil,
            queue: .main,
            using: { [weak self] _ in
                self?.fetchHomeFeed()
            })
        
        observer = NotificationCenter.default.addObserver(
            forName: .didNotifyFollowUnfollowUpdate,
            object: nil,
            queue: .main,
            using: { [weak self] _ in
                self?.fetchHomeFeed()
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
            self?.fetchHomeFeed()
        }
    }
    
    @objc private func didTapPost() {
        let vc = CreatePostViewController()
        vc.createPostCompletion = { [weak self] success in
            DispatchQueue.main.async {
                if success {
                    self?.fetchHomeFeed()
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

//    private func fetchMyPosts() {
//        ApiManager.shared.getMyPosts { [weak self] result in
//            DispatchQueue.main.async {
//                switch result {
//                case .success(let posts):
//                    self?.posts = posts
//                    self?.configureUI()
//                case .failure(let error):
//                    print(error)
//                }
//            }
//        }
//    }
    
    private func fetchHomeFeed() {
        posts.removeAll()
        ApiManager.shared.getHomeFeed { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let posts):
                    self?.posts = posts
                    self?.configureUI()
                case .failure(let error):
                    print(error)
                }
                self?.refreshControl.endRefreshing()
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
        }
        tableView.reloadData()
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
        cell.delegate = self
        let model = posts[indexPath.row]
        let viewModel = PostViewModel(caption: model.caption,
                                      name: model.name,
                                      likes: model.likes,
                                      contentUrl: URL(string: model.contentUrl),
                                      profilePictureUrl: URL(string: model.profilePictureUrl ?? ""),
                                      createdDate: String.formattedDate(
                                        string: model.createdDate,
                                        dateFormat: "MMM d, h:mm a"))
        cell.configure(with: viewModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 350
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
     
}

extension HomeViewController:PostTableViewCellDelegate {
    
    func postTableViewCell(_ cell: PostTableViewCell, didTapMoreButton button: UIButton) {
        
        guard let userId = UserDefaults.standard.value(forKey: "userId") as? String,
              let indexPath = tableView.indexPath(for: cell) else {
            return
        }

        let loggedInUserPost = posts[indexPath.row].userId == userId
        
        
    
        let actionSheet = UIAlertController(title: "Post",
                                            message: "Choose Option",
                                            preferredStyle: .actionSheet)
        
        if loggedInUserPost
        {
            actionSheet.addAction(
                UIAlertAction(
                    title: "Delete post",
                    style: .default,
                    handler: { [weak self] _ in
                        let alert = UIAlertController(
                            title: "Delete Post",
                            message: "Are you sure you want to delete this post ?",
                            preferredStyle: .alert)
                        
                        alert.addAction(
                            UIAlertAction(
                                title: "Delete",
                                style: .destructive, handler: { _ in
                                    self?.deletePost(indexPath: indexPath)
                                }))
                        
                        alert.addAction(
                            UIAlertAction(
                                title: "Cancel",
                                style: .cancel, handler: nil))
                        
                        self?.present(alert, animated: true)
                    }))
            
        }
        actionSheet.addAction(UIAlertAction(title: "Cancel",
                                            style: .cancel, handler: nil))
        
        present(actionSheet, animated: true)
    }
    
    func deletePost(indexPath:IndexPath) {
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
                    self?.tableView.insertRows(at: [indexPath],
                                         with: .left)
                }
                self?.configureUI()
            }
        }
        tableView.endUpdates()
    }

    func postTableViewCell(_ cell: PostTableViewCell, didTaplikeUnlikeButton button: UIButton) {
        
        guard let indexpath = tableView.indexPath(for: cell) else {
            return
        }
        
        let post = posts[indexpath.row]
        
        if button.accessibilityIdentifier == "hand.thumbsup" {
            
            ApiManager.shared.likePost(with: post._id) { [weak self] success in
                DispatchQueue.main.async {
                    if success {
                        button.setImage(UIImage(systemName: "hand.thumbsup.fill"),
                                        for: .normal)
                        button.accessibilityIdentifier = "hand.thumbsup.fill"
                        self?.fetchHomeFeed()
                    }
                }
            }
            
        } else {
            ApiManager.shared.unlikePost(with: post._id) { [weak self] success in
                DispatchQueue.main.async {
                    if success {
                        button.setImage(UIImage(systemName: "hand.thumbsup"),
                                        for: .normal)
                        button.accessibilityIdentifier = "hand.thumbsup"
                        self?.fetchHomeFeed()
                    }
                }
            }
        }
    }
    
    func postTableViewCell(_ cell: PostTableViewCell, didTaplikeCountLabel label: UILabel) {
        
        guard let indexpath = tableView.indexPath(for: cell) else {
            return
        }
        
        let post = posts[indexpath.row]
        let vc = ListUsersViewController(vcTitle: "Likes", isPostLikes: true,id: post._id)
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
