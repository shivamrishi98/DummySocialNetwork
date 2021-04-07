//
//  PostCollectionViewCell.swift
//  DummySocialNetwork
//
//  Created by Shivam Rishi on 06/04/21.
//

import UIKit
import SDWebImage

protocol PostCollectionViewCellDelegate:AnyObject {
    func postCollectionViewCell(_ cell:PostCollectionViewCell,didTaplikeUnlikeButton button:UIButton)
    func postCollectionViewCell(_ cell:PostCollectionViewCell,didTaplikeCountLabel label:UILabel)
    func postCollectionViewCell(_ cell:PostCollectionViewCell,didTapMoreButton button:UIButton)
    func postCollectionViewCell(_ cell:PostCollectionViewCell,didTapCommentButton button:UIButton)
    func postCollectionViewCell(_ cell:PostCollectionViewCell,didTapNameLabel label:UILabel)
}

final class PostCollectionViewCell: UICollectionViewCell {
    
    
    static let identifier = "PostCollectionViewCell"
    
    weak var delegate:PostCollectionViewCellDelegate?
    
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
    
    private let postImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .label
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let nameLabel:UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.numberOfLines = 0
        label.isUserInteractionEnabled = true
        return label
    }()
    
    private let captionLabel:UILabel = {
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
    
    private let moreButton:UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        button.tintColor = .label
        return button
    }()
    
    private let likeUnlikeButton:UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "hand.thumbsup")
        button.setImage(image, for: .normal)
        button.accessibilityIdentifier = "hand.thumbsup"
        button.tintColor = .label
        return button
    }()
    
    private let commentButton:UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "heart")
        button.setImage(image, for: .normal)
        button.tintColor = .label
        return button
    }()
    
    private let likeCountLabel:UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.isUserInteractionEnabled = true
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.isHidden = true
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(profileImageView)
        contentView.addSubview(postImageView)
        contentView.addSubview(dateCreatedLabel)
        contentView.addSubview(moreButton)
        contentView.addSubview(captionLabel)
        contentView.addSubview(nameLabel)
        contentView.addSubview(likeUnlikeButton)
        contentView.addSubview(commentButton)
        contentView.addSubview(likeCountLabel)
        
        profileImageView.layer.cornerRadius = 25/2
        
        moreButton.addTarget(self,
                             action: #selector(didTapMoreButton(_:)),
                             for: .touchUpInside)
        
        likeUnlikeButton.addTarget(self,
                                   action: #selector(didTaplikeUnlikeButton(_:)),
                                   for: .touchUpInside)
        
        commentButton.addTarget(self,
                                action: #selector(didTapCommentButton(_:)),
                                for: .touchUpInside)
        
        let gesture = UITapGestureRecognizer(target: self,
                                             action: #selector(didTaplikeCountLabel(_:)))
        likeCountLabel.addGestureRecognizer(gesture)
        
        let nameTapgesture = UITapGestureRecognizer(target: self,
                                             action: #selector(didTapNameLabel(_:)))
        nameLabel.addGestureRecognizer(nameTapgesture)
        
        
    }
    
    
    @objc private func didTapCommentButton(_ sender:UIButton) {
        delegate?.postCollectionViewCell(self,
                                         didTapCommentButton: sender)
    }
    
    @objc private func didTapMoreButton(_ sender:UIButton) {
        delegate?.postCollectionViewCell(self,
                                         didTapMoreButton: sender)
    }
    
    @objc private func didTaplikeCountLabel(_ sender:UILabel) {
        delegate?.postCollectionViewCell(self,
                                         didTaplikeCountLabel: sender)
    }
    
    @objc private func didTaplikeUnlikeButton(_ sender:UIButton) {
        delegate?.postCollectionViewCell(self,
                                         didTaplikeUnlikeButton: sender)
    }
    
    @objc private func didTapNameLabel(_ sender:UILabel) {
        delegate?.postCollectionViewCell(self,
                                         didTapNameLabel: sender)
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
                                        width: frame.width-profileImageView.width-nameLabel.width-60,
                                        height: 25)
        
        moreButton.frame = CGRect(x: dateCreatedLabel.right + 5,
                                  y: 5,
                                  width:20,
                                  height: 25)
        
        postImageView.frame = CGRect(x: 0,
                                     y: profileImageView.bottom + 5,
                                     width: frame.width,
                                     height: 250)
        
        captionLabel.frame = CGRect(x: 20,
                                    y: postImageView.bottom,
                                    width: frame.width-40,
                                    height: frame.height-profileImageView.height-postImageView.height-65)
        
        likeUnlikeButton.frame = CGRect(x: 20,
                                        y: captionLabel.bottom + 5,
                                        width: 20,
                                        height: 20)
        
        commentButton.frame = CGRect(x: likeUnlikeButton.right + 10,
                                     y: captionLabel.bottom + 5,
                                     width: 20,
                                     height: 20)
        
        likeCountLabel.frame = CGRect(x:20,
                                      y: likeUnlikeButton.bottom + 10,
                                      width: width-likeUnlikeButton.width-40,
                                      height: 20)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
        dateCreatedLabel.text = nil
        captionLabel.text = nil
        profileImageView.image = nil
        postImageView.image = nil
        moreButton.setImage(UIImage(systemName: "ellipsis"),
                            for: .normal)
        likeUnlikeButton.setImage(UIImage(systemName: "hand.thumbsup"),
                                  for: .normal)
        likeUnlikeButton.accessibilityIdentifier = "hand.thumbsup"
        likeCountLabel.text = nil
    }
    
    func configure(with viewModel:PostViewModel){
        
        nameLabel.text = viewModel.name
        dateCreatedLabel.text = viewModel.createdDate
        captionLabel.text = viewModel.caption
        profileImageView.sd_setImage(with: viewModel.profilePictureUrl,
                                     placeholderImage: UIImage(systemName: "person"),
                                     completed: nil)
        postImageView.sd_setImage(with: viewModel.contentUrl,
                                  placeholderImage: UIImage(systemName: "photo"),
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


