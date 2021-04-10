//
//  NotificationTableViewCell.swift
//  DummySocialNetwork
//
//  Created by Shivam Rishi on 09/04/21.
//

import UIKit
import SDWebImage

class NotificationTableViewCell: UITableViewCell {

    static let identifier = "NotificationTableViewCell"
    
    private let postImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .label
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let messageLabel:UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.numberOfLines = 0
        return label
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(messageLabel)
        contentView.addSubview(postImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    
        messageLabel.frame = CGRect(x: 10,
                                    y: 5,
                                    width: width-height-20,
                                    height: height-10)
        
        postImageView.frame = CGRect(x: messageLabel.right + 5,
                                     y: 5,
                                     width: height-10,
                                     height: height-10)
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        messageLabel.text = nil
        postImageView.image = nil
    }
    
    func configure(with viewModel:NotificationViewModel) {
        messageLabel.text = "\(viewModel.message) at \(viewModel.createdDate)"
        postImageView.sd_setImage(with: viewModel.contentUrl,
                               placeholderImage: UIImage(systemName: "photo"),
                               completed: nil)
    }


}
