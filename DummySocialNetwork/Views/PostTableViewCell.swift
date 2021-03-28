//
//  PostTableViewCell.swift
//  DummySocialNetwork
//
//  Created by Shivam Rishi on 28/03/21.
//

import UIKit

class PostTableViewCell: UITableViewCell {

    static let identifier = "PostTableViewCell"
    
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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        dateCreatedLabel.frame = CGRect(x: 10,
                                        y: 5,
                                        width: frame.width-20,
                                        height: 10)
        
        contentLabel.frame = CGRect(x: 10,
                                    y: dateCreatedLabel.bottom + 2,
                                    width: frame.width-20,
                                    height: frame.height-dateCreatedLabel.height-14)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        dateCreatedLabel.text = nil
        contentLabel.text = nil
    }
    
    func configure(with viewModel:PostViewModel){
        dateCreatedLabel.text = viewModel.createdDate
        contentLabel.text = viewModel.content
    }
    
}
