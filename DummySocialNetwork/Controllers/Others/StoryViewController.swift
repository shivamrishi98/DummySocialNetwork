//
//  StoryViewController.swift
//  DummySocialNetwork
//
//  Created by Shivam Rishi on 06/04/21.
//

import UIKit
import SDWebImage

class StoryViewController: UIViewController {

    private let story:Story
    
    private let imageView:UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .label
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
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
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.numberOfLines = 0
        return label
    }()
    
    private let dateCreatedLabel:UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .right
        return label
    }()
    
    
    init(story:Story) {
        self.story = story
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(imageView)
        imageView.addSubview(profileImageView)
        imageView.addSubview(nameLabel)
        imageView.addSubview(dateCreatedLabel)
        configure()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imageView.frame = view.bounds
        
        profileImageView.frame = CGRect(x: 10,
                                        y: 5,
                                        width: 25,
                                        height: 25)
        profileImageView.layer.cornerRadius = profileImageView.height/2
        nameLabel.frame = CGRect(x: profileImageView.right + 5,
                                 y: 5,
                                 width: view.width*0.50-profileImageView.width-30,
                                 height: 25)
        
        dateCreatedLabel.frame = CGRect(x: nameLabel.right + 5,
                                        y: 5,
                                        width: view.width-profileImageView.width-nameLabel.width-60,
                                        height: 25)
        
    }
    
   private func configure() {
    imageView.sd_setImage(with: URL(string: story.contentUrl),
                          placeholderImage: UIImage(systemName: "photo"),
                          completed: nil)
    profileImageView.sd_setImage(with: URL(string: story.createdBy.profilePictureUrl ?? ""),
                                 placeholderImage: UIImage(systemName: "person"),
                                 completed: nil)
    nameLabel.text = story.createdBy.name
    dateCreatedLabel.text = String.formattedDate(string: story.createdDate,
                                                 dateFormat: "MMM d, h:mm a")
    }

}
