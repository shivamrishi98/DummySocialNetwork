//
//  RecommendedUsersHeaderCollectionReusableView.swift
//  DummySocialNetwork
//
//  Created by Shivam Rishi on 02/04/21.
//

import UIKit

final class RecommendedUsersHeaderCollectionReusableView: UICollectionReusableView {
        
        static let identifier = "RecommendedUsersHeaderCollectionReusableView"
        
        private let titleLabel:UILabel = {
            let label = UILabel()
            label.textColor = .label
            label.font = .systemFont(ofSize: 16, weight: .semibold)
            label.numberOfLines = 0
            return label
        }()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            addSubview(titleLabel)
        }
        
        required init?(coder: NSCoder) {
            fatalError()
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            
            titleLabel.frame = CGRect(x: 5,
                                      y: 5,
                                      width: width-10,
                                      height: 40)
            
        }
        
        override func prepareForReuse() {
            super.prepareForReuse()
            titleLabel.text = nil
        }
        
        func configure(with title:String) {
            titleLabel.text = title
        }
        
        
    }


