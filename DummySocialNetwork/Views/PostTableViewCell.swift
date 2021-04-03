//
//  PostTableViewCell.swift
//  DummySocialNetwork
//
//  Created by Shivam Rishi on 28/03/21.
//

import UIKit
import SDWebImage

protocol PostTableViewCellDelegate:AnyObject {
    func postTableViewCell(_ cell:PostTableViewCell,didTaplikeUnlikeButton button:UIButton)
}

class PostTableViewCell: UITableViewCell {

    static let identifier = "PostTableViewCell"
    
    weak var delegate:PostTableViewCellDelegate?
    
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
    
    private let contentLabel:UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 18)
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
    
    private let likeUnlikeButton:UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "hand.thumbsup")
        button.setImage(image, for: .normal)
        button.accessibilityIdentifier = "hand.thumbsup"
        button.tintColor = .label
        return button
    }()
    
    private let likeCountLabel:UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.isHidden = true
        return label
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(profileImageView)
        contentView.addSubview(dateCreatedLabel)
        contentView.addSubview(contentLabel)
        contentView.addSubview(nameLabel)
        contentView.addSubview(likeUnlikeButton)
        contentView.addSubview(likeCountLabel)
        
        profileImageView.layer.cornerRadius = 25/2
        
        likeUnlikeButton.addTarget(self,
                                   action: #selector(didTaplikeUnlikeButton(_:)),
                                   for: .touchUpInside)
    }
    
    @objc private func didTaplikeUnlikeButton(_ sender:UIButton) {
        delegate?.postTableViewCell(self,
                                    didTaplikeUnlikeButton: sender)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        profileImageView.frame = CGRect(x: 10,
                                        y: 5,
                                        width: 25,
                                        height: 25)
        
        nameLabel.frame = CGRect(x: profileImageView.right + 5,
                                 y: 5,
                                 width: frame.width*0.60-profileImageView.width-30,
                                 height: 25)
        
        dateCreatedLabel.frame = CGRect(x: nameLabel.right + 5,
                                        y: 5,
                                        width: frame.width-profileImageView.width-nameLabel.width-40,
                                        height: 25)
        
        contentLabel.frame = CGRect(x: 40,
                                    y: profileImageView.bottom,
                                    width: frame.width-50,
                                    height: frame.height-profileImageView.height-35)
        
        likeUnlikeButton.frame = CGRect(x: 40,
                                    y: contentLabel.bottom + 5,
                                    width: 20,
                                    height: 20)
        
        likeCountLabel.frame = CGRect(x: likeUnlikeButton.right + 10,
                                    y: contentLabel.bottom + 5,
                                    width: width-likeUnlikeButton.width-20,
                                    height: 20)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
        dateCreatedLabel.text = nil
        contentLabel.text = nil
        profileImageView.image = nil
        likeUnlikeButton.setImage(UIImage(systemName: "hand.thumbsup"),
                                  for: .normal)
        likeUnlikeButton.accessibilityIdentifier = "hand.thumbsup"
        likeCountLabel.text = nil
    }
    
    func configure(with viewModel:PostViewModel){
                
        nameLabel.text = viewModel.name
        dateCreatedLabel.text = viewModel.createdDate
        contentLabel.text = viewModel.content
        profileImageView.sd_setImage(with: viewModel.profilePictureUrl,
                                     placeholderImage: UIImage(systemName: "person"),
                                     completed: nil)
        
        let likesExist = viewModel.likes.isEmpty
        let likesCount = viewModel.likes.count

        if !likesExist {
            likeCountLabel.isHidden = false
            
            if likesCount == 1 {
                likeCountLabel.text = "\(likesCount) like"
            } else {
                likeCountLabel.text = "\(likesCount) likes"
            }
            
        }
        
        guard let userId = UserDefaults.standard.value(forKey: "userId") as? String else {
            return
        }
        
        let exists = viewModel.likes.filter({
            $0 == userId
        })
        
        if !exists.isEmpty {
            likeUnlikeButton.setImage(UIImage(systemName: "hand.thumbsup.fill"),
                                      for: .normal)
            likeUnlikeButton.accessibilityIdentifier = "hand.thumbsup.fill"
        }
        
    }
    
}
