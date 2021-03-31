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
    private let userId:String?
    private let isOwner:Bool
    
    init(isOwner:Bool = false,userId:String? = nil) {
        self.isOwner = isOwner
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
    
    private let accountCreatedDateLabel:UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 18)
        return label
    }()
    
    private var observer:NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Profile"
        view.backgroundColor = . systemBackground
        view.addSubview(nameLabel)
        view.addSubview(emailLabel)
        view.addSubview(postsCountLabel)
        view.addSubview(accountCreatedDateLabel)
        view.addSubview(profileImageView)
        
        profileImageView.layer.masksToBounds = true
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
        } else {
            guard let userId = userId else {
                return
            }
            fetchUserProfile(userId: userId)
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
                                email: user.email,
                                postsCount: user.posts.count,
                                profileImageUrl:URL(string: user.profilePictureUrl ?? ""),
                                dateCreated: user.createdDate))
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
                    self?.configure(
                        with:
                            ProfileViewModel(
                                name: user.name,
                                email: user.email,
                                postsCount: user.posts.count,
                                profileImageUrl: URL(string: user.profilePictureUrl ?? ""),
                                dateCreated: user.createdDate))
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
        profileImageView.sd_setImage(with: viewModel.profileImageUrl,
                                     placeholderImage: UIImage(systemName: "person"),
                                     completed: nil)
        let date = String.formattedDate(string: viewModel.dateCreated)
        accountCreatedDateLabel.text = "Creation Date: \(date)"
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        profileImageView.frame = CGRect(x: view.width/2-75,
                                        y: view.safeAreaInsets.top + 10,
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
        
        accountCreatedDateLabel.frame = CGRect(x: 10,
                                  y: postsCountLabel.bottom + 10,
                                 width: view.width-20,
                                 height: 20)
        
    }

}
