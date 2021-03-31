//
//  SearchResultsViewController.swift
//  DummySocialNetwork
//
//  Created by Shivam Rishi on 30/03/21.
//

import UIKit

protocol SearchResultsViewControllerDelegate:AnyObject {
    func searchResultsViewControllerDidSelectUser(_ result:User)
}

class SearchResultsViewController: UIViewController {

    private var users = [User]()
    
    weak var delegate:SearchResultsViewControllerDelegate?
    
     private let tableView:UITableView = {
        let tableView = UITableView()
        tableView.isHidden = true
        tableView.register(SearchResultsTableViewCell.self,
                           forCellReuseIdentifier: SearchResultsTableViewCell.identifier)
        return tableView
    }()
    
    private let noUserLabel:UILabel = {
        let label = UILabel()
        label.text = "No User Found"
        label.isHidden = true
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        view.addSubview(noUserLabel)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        
        noUserLabel.frame = CGRect(x: 0,
                                    y: 0,
                                    width: view.width,
                                    height: 50)
        noUserLabel.center = view.center
    }
    
    func update(with users:[User]) {
        
        DispatchQueue.main.async { [weak self] in
            self?.users = users
            self?.configureUI()
        }
    }
    
    func removeUserFromResults() {
        DispatchQueue.main.async { [weak self] in
            self?.users.removeAll()
            self?.tableView.reloadData()
        }
    }
    
    func configureUI() {
        if users.isEmpty {
            noUserLabel.isHidden = false
            tableView.isHidden = true
        } else {
            noUserLabel.isHidden = true
            tableView.isHidden = false
            tableView.reloadData()
        }
        
    }
    
    func hideNoUserLabel() {
        noUserLabel.isHidden = true
    }

}

extension SearchResultsViewController:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
                withIdentifier: SearchResultsTableViewCell.identifier,
                for: indexPath) as? SearchResultsTableViewCell else {
            return UITableViewCell()
        }
        
        let model = users[indexPath.row]
        let viewModel = SearchResultsViewModel(
            name: model.name,
            profilePictureUrl: URL(string: model.profilePictureUrl ?? ""))
        cell.configure(with: viewModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = users[indexPath.row]
        delegate?.searchResultsViewControllerDidSelectUser(model)
    }
    
}
