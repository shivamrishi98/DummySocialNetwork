//
//  HomeViewController.swift
//  DummySocialNetwork
//
//  Created by Shivam Rishi on 27/03/21.
//

import UIKit

final class HomeViewController: UIViewController {

    private var posts = [Post]()
    private var stories = [Story]()
    
    private let collectionView:UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewCompositionalLayout(
                sectionProvider: { section, _ -> NSCollectionLayoutSection? in
                    return HomeViewController.createSectionLayout(section: section)
                }))
        collectionView.backgroundColor = .systemBackground
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(PostCollectionViewCell.self,
                                forCellWithReuseIdentifier: PostCollectionViewCell.identifier)
        collectionView.register(RecommendedUsersCollectionViewCell.self,
                                forCellWithReuseIdentifier: RecommendedUsersCollectionViewCell.identifier)
        return collectionView
    }()
    
    private static func createSectionLayout(section:Int) -> NSCollectionLayoutSection {
        
        
        switch section {
        
        case 0:
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                  heightDimension: .fractionalHeight(1))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 2,
                                                         leading: 2,
                                                         bottom: 2,
                                                         trailing: 2)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                   heightDimension: .absolute(100))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                           subitem: item,
                                                           count: 5)
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuous
            return section
        case 1:
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                  heightDimension: .fractionalHeight(1))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 2,
                                                         leading: 2,
                                                         bottom: 2,
                                                         trailing: 2)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                   heightDimension: .absolute(380))
            
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize,
                                                           subitem: item,
                                                           count: 1)
            let section = NSCollectionLayoutSection(group: group)
            return section
        default:
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                  heightDimension: .fractionalHeight(1))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 2,
                                                         leading: 2,
                                                         bottom: 2,
                                                         trailing: 2)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                   heightDimension: .absolute(380))
            
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize,
                                                           subitem: item,
                                                           count: 1)
            let section = NSCollectionLayoutSection(group: group)
            return section
        }
        
    }
    
    private let refreshControl:UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        return refreshControl
    }()
    

    private var observer:NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Home"
        view.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.refreshControl = refreshControl
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
        collectionView.frame = view.bounds
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
        stories.removeAll()
        
        let group = DispatchGroup()
        group.enter()
        group.enter()
        
        ApiManager.shared.getHomeFeed { [weak self] result in
            defer {
                group.leave()
            }
            DispatchQueue.main.async {
                switch result {
                case .success(let posts):
                    self?.posts = posts
                case .failure(let error):
                    print(error)
                }
                self?.refreshControl.endRefreshing()
            }
        }
        
        fetchStories(group:group)
        
        group.notify(queue: .main) { [weak self] in
            self?.configureUI()
            self?.refreshControl.endRefreshing()
        }
        
        
    }
    
    private func fetchStories(group:DispatchGroup? = nil) {
        ApiManager.shared.getAllStories { [weak self] result in
            defer {
                group?.leave()
            }
            DispatchQueue.main.async {
                switch result {
                case .success(let stories):
                    self?.stories = stories
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
        collectionView.reloadData()
    }
    
}

extension HomeViewController:UICollectionViewDelegate,UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return stories.count + 1
        case 1:
            return posts.count
        default:
            return 0
        }
    }
    

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
        switch indexPath.section {
        case  0:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendedUsersCollectionViewCell.identifier,for: indexPath) as? RecommendedUsersCollectionViewCell else {
                return UICollectionViewCell()
            }
            switch indexPath.row {
            case 0:
            cell.configure()
            default:
                let model = stories[indexPath.row-1]
                let viewModel = RecommendedUsersViewModel(
                    name: model.createdBy.name,
                    profilePictureUrl: URL(string: model.createdBy.profilePictureUrl ?? ""))
                cell.configure(with: viewModel)
            }
            return cell
        case 1:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostCollectionViewCell.identifier,for: indexPath) as? PostCollectionViewCell else {
                return UICollectionViewCell()
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
            
        default:
            return UICollectionViewCell()
        }

    }
     
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                let picker = UIImagePickerController()
                picker.allowsEditing = true
                picker.delegate = self
                present(picker, animated: true)
            default:
                let story = stories[indexPath.row-1]
                let vc = StoryViewController(story: story)
                present(vc, animated: true)
            }
        default:
            break
        }
        
    }
    
}

extension HomeViewController:PostCollectionViewCellDelegate {
    
    func postCollectionViewCell(_ cell: PostCollectionViewCell, didTaplikeUnlikeButton button: UIButton) {
        
        guard let indexpath = collectionView.indexPath(for: cell) else {
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
    
    func postCollectionViewCell(_ cell: PostCollectionViewCell, didTaplikeCountLabel label: UILabel) {
        
        guard let indexpath = collectionView.indexPath(for: cell) else {
            return
        }
        
        let post = posts[indexpath.row]
        let vc = ListUsersViewController(vcTitle: "Likes", isPostLikes: true,id: post._id)
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func postCollectionViewCell(_ cell: PostCollectionViewCell, didTapMoreButton button: UIButton) {
        
        guard let userId = UserDefaults.standard.value(forKey: "userId") as? String,
              let indexPath = collectionView.indexPath(for: cell) else {
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
    
    func postCollectionViewCell(_ cell: PostCollectionViewCell, didTapCommentButton button: UIButton) {
        
        guard let indexPath = collectionView.indexPath(for: cell) else {
            return
        }

        let model = posts[indexPath.row]
        
        let vc = CommentsViewController(postId: model._id)
        navigationController?.pushViewController(vc, animated: true)
    }
    


    func deletePost(indexPath:IndexPath) {
        let postId = posts[indexPath.row]._id
        let deletedPost = posts.remove(at: indexPath.row)
        collectionView.deleteItems(at: [indexPath])
        ApiManager.shared.deletePost(with: postId) { [weak self] success in
            DispatchQueue.main.async {
                if !success {
                    // add model and row back and show error alert
                    self?.posts.insert(deletedPost, at: indexPath.row)
                    self?.collectionView.insertItems(at: [indexPath])
                }
                self?.configureUI()
            }
        }
    }
    
    func postCollectionViewCell(_ cell: PostCollectionViewCell, didTapNameLabel label: UILabel) {
                
        guard let userId = UserDefaults.standard.value(forKey: "userId") as? String else {
            return
        }
        
        guard let indexPath = collectionView.indexPath(for: cell) else {
            return
        }

        let model = posts[indexPath.row]
        
        let loggedInUser = model.userId == userId
        
        if loggedInUser {
            let vc = ProfileViewController(isOwner: true,
                                           userId:model.userId)
            navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = ProfileViewController(userId: model.userId)
            navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    
}
    
extension HomeViewController:UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
       
        guard let image = info[.editedImage] as? UIImage,
              let imageData = image.jpegData(compressionQuality: 1),
              let imageUrl = info[.imageURL]as? URL,
              let fileName = imageUrl.pathComponents.last else {
            return
        }
        
        let mimeType = "image/\(imageUrl.pathExtension)"
        
        let request = ProfilePictureRequest(fileName: fileName,
                                            mimeType: mimeType,
                                            imageData: imageData)
        ApiManager.shared.createStory(request: request) { [weak self] success in
            DispatchQueue.main.async {
                if success {
                    picker.dismiss(animated: true) {
                        self?.fetchStories()
                    }
                }
                
            }
        }
    }
}


