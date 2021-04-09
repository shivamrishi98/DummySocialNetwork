//
//  NotificationTableViewCell.swift
//  DummySocialNetwork
//
//  Created by Shivam Rishi on 09/04/21.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {

    static let identifier = "NotificationTableViewCell"
    
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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    
        messageLabel.frame = CGRect(x: 10,
                                    y: 5,
                                    width: frame.width-30,
                                    height: height-10)
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        messageLabel.text = nil
    }
    
    func configure(with viewModel:NotificationViewModel) {
        messageLabel.text = "\(viewModel.message) at \(viewModel.createdDate)"
    }


}
