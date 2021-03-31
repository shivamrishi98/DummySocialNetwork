//
//  PostTableViewCell.swift
//  DummySocialNetwork
//
//  Created by Shivam Rishi on 28/03/21.
//

import UIKit
import SDWebImage

class PostTableViewCell: UITableViewCell {

    static let identifier = "PostTableViewCell"
    
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
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(profileImageView)
        contentView.addSubview(dateCreatedLabel)
        contentView.addSubview(contentLabel)
        contentView.addSubview(nameLabel)
        
        profileImageView.layer.cornerRadius = 25/2
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
                                 y: 10,
                                 width: frame.width*0.60-profileImageView.width-30,
                                 height: 15)
        
        dateCreatedLabel.frame = CGRect(x: nameLabel.right + 5,
                                        y: 5,
                                        width: frame.width-profileImageView.width-nameLabel.width,
                                        height: 15)

        contentLabel.frame = CGRect(x: 40,
                                    y: profileImageView.bottom,
                                    width: frame.width-50,
                                    height: frame.height-profileImageView.height-10)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
        dateCreatedLabel.text = nil
        contentLabel.text = nil
        profileImageView.image = nil
    }
    
    func configure(with viewModel:PostViewModel){
        nameLabel.text = viewModel.name
        dateCreatedLabel.text = viewModel.createdDate
        contentLabel.text = viewModel.content
        profileImageView.sd_setImage(with: viewModel.profilePictureUrl,
                                     placeholderImage: UIImage(systemName: "person"),
                                     completed: nil)
    }
    
}
