//
//  SearchResultsTableViewCell.swift
//  DummySocialNetwork
//
//  Created by Shivam Rishi on 30/03/21.
//

import UIKit

class SearchResultsTableViewCell: UITableViewCell {

    static let identifier = "SearchResultsTableViewCell"
    
    private let nameLabel:UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(nameLabel)
        accessoryType = .disclosureIndicator
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        nameLabel.frame = CGRect(x: 10,
                                 y: 5,
                                 width: width-20,
                                 height: height-10)
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
    }
    
    func configure(with viewModel:SearchResultsViewModel) {
        nameLabel.text = viewModel.name
    }

}
