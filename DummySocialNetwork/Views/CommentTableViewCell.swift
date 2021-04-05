//
//  CommentTableViewCell.swift
//  DummySocialNetwork
//
//  Created by Shivam Rishi on 05/04/21.
//

import UIKit
import SDWebImage

class CommentTableViewCell: UITableViewCell {

    static let identifier = "CommentTableViewCell"
    
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
    
    private let createdDateLabel:UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        label.numberOfLines = 0
        label.textAlignment = .right
        return label
    }()
    
    private let commentLabel:UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(profileImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(createdDateLabel)
        contentView.addSubview(commentLabel)
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
        profileImageView.layer.cornerRadius = profileImageView.height/2
        
        nameLabel.frame = CGRect(x: profileImageView.right + 5,
                                 y: 5,
                                 width: frame.width*0.70-profileImageView.width-30,
                                 height: 25)
        
        createdDateLabel.frame = CGRect(x: nameLabel.right + 5 ,
                                        y: 5,
                                        width: frame.width-profileImageView.width-nameLabel.width-30,
                                        height: 25)
        
        commentLabel.frame = CGRect(x: 40,
                                    y: nameLabel.bottom + 5,
                                    width: frame.width-60,
                                    height: frame.height-profileImageView.height-14)
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profileImageView.image = nil
        nameLabel.text = nil
        createdDateLabel.text = nil
        commentLabel.text = nil
    }
    
    func configure(with viewModel:CommentViewModel) {
        nameLabel.text = viewModel.name
        profileImageView.sd_setImage(with: viewModel.profilePictureUrl,
                                     placeholderImage: UIImage(systemName: "person"),
                                     completed: nil)
        createdDateLabel.text = viewModel.createdDate
        commentLabel.text = viewModel.comment
    }

}
