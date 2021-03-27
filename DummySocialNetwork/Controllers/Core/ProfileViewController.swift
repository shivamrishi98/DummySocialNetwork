//
//  ProfileViewController.swift
//  DummySocialNetwork
//
//  Created by Shivam Rishi on 27/03/21.
//

import UIKit


final class ProfileViewController: UIViewController {

    private var user:User?
    
    private let nameLabel:UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 18)
        return label
    }()
    
    private let emailLabel:UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 18)
        return label
    }()
    
    private let accountCreatedDateLabel:UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 18)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = . systemBackground
        view.addSubview(nameLabel)
        view.addSubview(emailLabel)
        view.addSubview(accountCreatedDateLabel)
        fetchData()
    }
    
    private func fetchData() {
        ApiManager.shared.getUserProfile { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let user):
                    self?.user = user
                    self?.configure(
                        with:
                            ProfileViewModel(
                                name: user.name,
                                email: user.email,
                                dateCreated: user.Date))
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    private func configure(with viewModel:ProfileViewModel) {
        nameLabel.text = "Name: \(viewModel.name)"
        emailLabel.text = "Email: \(viewModel.email)"
        let date = String.formattedDate(string: viewModel.dateCreated)
        accountCreatedDateLabel.text = "Creation Date: \(date)"
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        nameLabel.frame = CGRect(x: 10,
                                 y: view.safeAreaInsets.top + 10,
                                 width: view.width-20,
                                 height: 20)
        emailLabel.frame = CGRect(x: 10,
                                  y: nameLabel.bottom + 10,
                                 width: view.width-20,
                                 height: 20)
        
        accountCreatedDateLabel.frame = CGRect(x: 10,
                                  y: emailLabel.bottom + 10,
                                 width: view.width-20,
                                 height: 20)
        
    }

}
