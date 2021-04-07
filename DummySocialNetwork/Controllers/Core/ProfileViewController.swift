//
//  ProfileViewController.swift
//  DummySocialNetwork
//
//  Created by Shivam Rishi on 27/03/21.
//

import UIKit
import SDWebImage

final class ProfileViewController: UIViewController {

    private var user:User?
    private var userId:String?
    private let isOwner:Bool
    
    init(isOwner:Bool = false,user:User? = nil,userId:String? = nil) {
        self.isOwner = isOwner
        self.user = user
        self.userId = userId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let profileImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .label
        imageView.contentMode = .scaleAspectFill
        let layer = imageView.layer
        layer.borderWidth = 1
        layer.borderColor = UIColor.label.cgColor
        layer.masksToBounds = true
        return imageView
    }()
    
    private let nameLabel:UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 18)
        return label
    }()
    
    private let emailLabel:UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 18)
        return label
    }()
    
    private let postsCountLabel:UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 18)
        return label
    }()
    
    private let followersCountLabel:UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 18)
        return label
    }()
    
    private let followingCountLabel:UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 18)
        return label
    }()
    
    private let accountCreatedDateLabel:UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 18)
        return label
    }()
    
    private let actionButton:UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Follow", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        button.backgroundColor = .systemBlue
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 12
        button.isHidden = true
        return button
    }()
    
    private let showFollowersListButton:UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Show list", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        button.backgroundColor = .systemBlue
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 5
        return button
    }()
    
    private let showFollowingsListButton:UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Show list", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        button.backgroundColor = .systemBlue
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 5
        return button
    }()
    
    private let lockImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.isHidden = true
        imageView.image = UIImage(systemName: "lock.circle")
        imageView.tintColor = .label
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private var observer:NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Profile"
        view.backgroundColor = .systemBackground
        view.addSubview(nameLabel)
        view.addSubview(emailLabel)
        view.addSubview(postsCountLabel)
        view.addSubview(accountCreatedDateLabel)
        view.addSubview(followersCountLabel)
        view.addSubview(followingCountLabel)
        view.addSubview(profileImageView)
        view.addSubview(actionButton)
        view.addSubview(showFollowersListButton)
        view.addSubview(showFollowingsListButton)
        view.addSubview(lockImageView)
        profileImageView.layer.cornerRadius = 75
        
        if isOwner {
            navigationItem.rightBarButtonItems = [
                UIBarButtonItem(image: UIImage(systemName: "gear"),
                                style: .plain,
                                target: self,
                                action: #selector(didTapSettings)),
                UIBarButtonItem(
                    image: UIImage(systemName: "pencil.circle"),
                    style: .plain,
                    target: self,
                    action: #selector(didTapEditProfile))
            ]
            fetchMyProfile()
            observer = NotificationCenter.default.addObserver(
                forName: .didNotifyPostCount,
                object: nil,
                queue: .main,
                using: { [weak self] _ in
                    self?.fetchMyProfile()
                })
            observer = NotificationCenter.default.addObserver(
                forName: .didNotifyFollowUnfollowUpdate,
                object: nil,
                queue: .main,
                using: { [weak self] _ in
                    self?.fetchMyProfile()
                })
            
        } else {
    
            if let userId = userId {
                fetchUserProfile(userId: userId)
            } else {
                
                guard let user = user else {
                    return
                }
                let viewModel = ProfileViewModel(
                    name: user.name,
                    email: user.email ?? "",
                    postsCount: user.posts?.count ?? 0,
                    followersCount: user.followers?.count ?? 0,
                    followingsCount: user.following?.count ?? 0,
                    profileImageUrl: URL(string: user.profilePictureUrl ?? ""),
                    dateCreated: user.createdDate ?? "")
                
                DispatchQueue.main.async { [weak self] in
                    self?.configure(with: viewModel)
                }
                checkForPrivateAccount()
                checkForAction()
            }
            actionButton.isHidden = false
        }
        
        actionButton.addTarget(self,
                               action: #selector(didTapActionButton),
                               for: .touchUpInside)
        showFollowersListButton.addTarget(self,
                               action: #selector(didTapShowFollowerListButton),
                               for: .touchUpInside)
        showFollowingsListButton.addTarget(self,
                               action: #selector(didTapShowFollowingListButton),
                               for: .touchUpInside)
        
    }
    
    @objc private func didTapShowFollowerListButton() {
        guard let user = user else {
            return
        }
        let vc = ListUsersViewController(vcTitle: "Followers",
                                         id: user._id)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func didTapShowFollowingListButton() {
        guard let user = user else {
            return
        }
        let vc = ListUsersViewController(vcTitle: "Followings",
                                         isFollowing: true,
                                         id: user._id)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func didTapActionButton() {
        
        guard let userId = user?._id else {
            return
        }
        if  actionButton.titleLabel?.text == "Follow" {
            ApiManager.shared.followUser(with: userId) { [weak self] success in
                DispatchQueue.main.async {
                    self?.actionButton.setTitle("Unfollow", for: .normal)
                    self?.fetchUserProfile(userId: userId)
                    NotificationCenter.default.post(name: .didNotifyFollowUnfollowUpdate,
                                                    object: nil,
                                                    userInfo: nil)
                }
            }
        } else {
            ApiManager.shared.unfollowUser(with: userId) { [weak self] success in
                DispatchQueue.main.async {
                    self?.actionButton.setTitle("Follow", for: .normal)
                    self?.fetchUserProfile(userId: userId)
                    NotificationCenter.default.post(name: .didNotifyFollowUnfollowUpdate,
                                                    object: nil,
                                                    userInfo: nil)
                }
            }
        }
    }
    
    @objc private func didTapSettings() {
        let vc = SettingsViewController()
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .fullScreen
        present(navVC, animated: true)
    }
        
    @objc private func didTapEditProfile() {
        
        guard let user = user else {
            return
        }
        let vc = EditProfileViewController(user: user)
        vc.saveCompletion = { [weak self] success in
            if success {
                self?.fetchMyProfile()
            }
        }
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .fullScreen
        navVC.navigationBar.tintColor = .label
        present(navVC, animated: true)
    }
    
    private func fetchMyProfile() {
        ApiManager.shared.getUserProfile { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let user):
                    self?.user = user
                    self?.configure(
                        with:
                            ProfileViewModel(
                                name: user.name,
                                email: user.email ?? "",
                                postsCount: user.posts?.count ?? 0,
                                followersCount: user.followers?.count ?? 0,
                                followingsCount: user.following?.count ?? 0,
                                profileImageUrl:URL(string: user.profilePictureUrl ?? ""),
                                dateCreated: user.createdDate ?? ""))
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    private func fetchUserProfile(userId:String) {
        ApiManager.shared.getUserProfile(with:userId) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let user):
                    self?.user = user
                    self?.checkForPrivateAccount()
                    self?.checkForAction()
                    self?.configure(
                        with:
                            ProfileViewModel(
                                name: user.name,
                                email: user.email ?? "",
                                postsCount: user.posts?.count ?? 0,
                                followersCount: user.followers?.count ?? 0,
                                followingsCount: user.following?.count ?? 0,
                                profileImageUrl: URL(string: user.profilePictureUrl ?? ""),
                                dateCreated: user.createdDate ?? ""))
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    private func configure(with viewModel:ProfileViewModel) {
        nameLabel.text = "Name: \(viewModel.name)"
        emailLabel.text = "Email: \(viewModel.email)"
        postsCountLabel.text = "Posts: \(viewModel.postsCount)"
        followersCountLabel.text = "Followers: \(viewModel.followersCount)"
        followingCountLabel.text = "Followings: \(viewModel.followingsCount)"
        profileImageView.sd_setImage(with: viewModel.profileImageUrl,
                                     placeholderImage: UIImage(systemName: "person"),
                                     completed: nil)
        let date = String.formattedDate(string: viewModel.dateCreated)
        accountCreatedDateLabel.text = "Creation Date: \(date)"
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    
        actionButton.frame = CGRect(x: view.width-120,
                                    y: view.safeAreaInsets.top + 10,
                                    width: 100,
                                    height: 44)
        
        profileImageView.frame = CGRect(x: view.width/2-75,
                                        y: actionButton.bottom + 10,
                                        width: 150,
                                        height: 150)
    
        
        nameLabel.frame = CGRect(x: 10,
                                 y: profileImageView.bottom + 10,
                                 width: view.width-20,
                                 height: 20)
        emailLabel.frame = CGRect(x: 10,
                                  y: nameLabel.bottom + 10,
                                 width: view.width-20,
                                 height: 20)
        
        postsCountLabel.frame = CGRect(x: 10,
                                  y: emailLabel.bottom + 10,
                                 width: view.width-20,
                                 height: 20)
        
        followersCountLabel.frame = CGRect(x: 10,
                                  y: postsCountLabel.bottom + 10,
                                  width: view.width*0.65-20,
                                 height: 20)
        
        showFollowersListButton.frame = CGRect(x: followersCountLabel.right + 10,
                                  y: postsCountLabel.bottom + 10,
                                  width: view.width-followersCountLabel.width-30,
                                 height: 20)
        
        followingCountLabel.frame = CGRect(x: 10,
                                  y: followersCountLabel.bottom + 10,
                                 width: view.width*0.65-20,
                                 height: 20)
        
        showFollowingsListButton.frame = CGRect(x: followingCountLabel.right + 10,
                                  y: followersCountLabel.bottom + 10,
                                  width: view.width-followingCountLabel.width-30,
                                 height: 20)
        
        accountCreatedDateLabel.frame = CGRect(x: 10,
                                  y: followingCountLabel.bottom + 10,
                                 width: view.width-20,
                                 height: 20)
        
        lockImageView.frame = CGRect(x: view.width/2-50,
                                     y: view.height/2 + 100,
                                     width: 100,
                                     height: 100)
        
    }
    
    private func checkForAction(){
        
        guard let loggedInUserId = UserDefaults.standard.value(forKey: "userId") as? String else {
            return
        }
        
        
        
        guard let follower = user?.followers?.filter({
            return $0 == loggedInUserId
        }) else {
            return
        }
        
        let followerExists = !follower.isEmpty

        if followerExists{
            actionButton.setTitle("Unfollow", for: .normal)
            return
        }

        actionButton.setTitle("Follow", for: .normal)
        
    }
    
    private func checkForPrivateAccount() {
        
        guard let user = user else {
            return
        }
        
        guard let loggedInUserId = UserDefaults.standard.value(forKey: "userId") as? String else {
            return
        }
        
        let notAFollower = user.followers?.filter({
            return $0 == loggedInUserId
       }).isEmpty ?? true
        
        if user.isPrivate && notAFollower{
            emailLabel.isHidden = true
            postsCountLabel.isHidden = true
            followersCountLabel.isHidden = true
            followingCountLabel.isHidden = true
            accountCreatedDateLabel.isHidden = true
            showFollowersListButton.isHidden = true
            showFollowingsListButton.isHidden = true
            lockImageView.isHidden = false
        } else {
            emailLabel.isHidden = false
            postsCountLabel.isHidden = false
            followersCountLabel.isHidden = false
            followingCountLabel.isHidden = false
            accountCreatedDateLabel.isHidden = false
            showFollowersListButton.isHidden = false
            showFollowingsListButton.isHidden = false
            lockImageView.isHidden = true
        }
        
        
    }
    
    
}
