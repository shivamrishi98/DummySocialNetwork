//
//  SearchResultsTableViewCell.swift
//  DummySocialNetwork
//
//  Created by Shivam Rishi on 30/03/21.
//

import UIKit
import SDWebImage

class SearchResultsTableViewCell: UITableViewCell {

    static let identifier = "SearchResultsTableViewCell"
    
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
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(profileImageView)
        contentView.addSubview(nameLabel)
        profileImageView.layer.cornerRadius = (height-10)/2
        accessoryType = .disclosureIndicator
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        profileImageView.frame = CGRect(x: 10,
                                 y: 5,
                                 width: height-10,
                                 height: height-10)
        
        nameLabel.frame = CGRect(x: profileImageView.right + 10,
                                 y: 5,
                                 width: width-profileImageView.width-20,
                                 height: height-10)
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
        profileImageView.image = nil
        
    }
    
    func configure(with viewModel:SearchResultsViewModel) {
        nameLabel.text = viewModel.name
        profileImageView.sd_setImage(with: viewModel.profilePictureUrl,
                                     placeholderImage: UIImage(systemName: "person"),
                                     completed: nil)
    }

}
