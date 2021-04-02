//
//  RecommendedUsersCollectionViewCell.swift
//  DummySocialNetwork
//
//  Created by Shivam Rishi on 02/04/21.
//

import UIKit
import SDWebImage

class RecommendedUsersCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "RecommendedUsersCollectionViewCell"
    
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
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(profileImageView)
        contentView.addSubview(nameLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        profileImageView.frame = CGRect(x: 5,
                                        y: 2,
                                        width: width-10,
                                        height: width-10)
        profileImageView.layer.cornerRadius = profileImageView.height/2
        
        nameLabel.frame = CGRect(x: 2,
                                 y: profileImageView.bottom + 2,
                                 width: width-4,
                                 height: height-profileImageView.height-5)
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profileImageView.image = nil
        nameLabel.text = nil
    }
    
    func configure(with viewModel:RecommendedUsersViewModel) {
        nameLabel.text = viewModel.name
        profileImageView.sd_setImage(with: viewModel.profilePictureUrl,
                                     placeholderImage: UIImage(systemName: "person"),
                                     completed: nil)
    }
    
    
}
