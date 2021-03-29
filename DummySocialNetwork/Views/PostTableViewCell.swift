//
//  PostTableViewCell.swift
//  DummySocialNetwork
//
//  Created by Shivam Rishi on 28/03/21.
//

import UIKit

class PostTableViewCell: UITableViewCell {

    static let identifier = "PostTableViewCell"
    
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
        contentView.addSubview(dateCreatedLabel)
        contentView.addSubview(contentLabel)
        contentView.addSubview(nameLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        nameLabel.frame = CGRect(x: 10,
                                 y: 5,
                                 width: frame.width*0.65-20,
                                 height: 15)
        
        dateCreatedLabel.frame = CGRect(x: nameLabel.right + 10,
                                        y: 5,
                                        width: frame.width-nameLabel.width-20,
                                        height: 15)

        contentLabel.frame = CGRect(x: 10,
                                    y: dateCreatedLabel.bottom + 2,
                                    width: frame.width-20,
                                    height: frame.height-dateCreatedLabel.height-14)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
        dateCreatedLabel.text = nil
        contentLabel.text = nil
    }
    
    func configure(with viewModel:PostViewModel){
        nameLabel.text = viewModel.name
        dateCreatedLabel.text = viewModel.createdDate
        contentLabel.text = viewModel.content
    }
    
}
