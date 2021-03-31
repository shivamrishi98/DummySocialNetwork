//
//  SearchUsersViewController.swift
//  DummySocialNetwork
//
//  Created by Shivam Rishi on 30/03/21.
//

import UIKit

class SearchViewController: UIViewController {
    
    private let searchController:UISearchController = {
        let searchController = UISearchController(
            searchResultsController: SearchResultsViewController())
        searchController.searchBar.placeholder = "Search Users..."
        searchController.searchBar.searchBarStyle = .minimal
        searchController.definesPresentationContext = true
        return searchController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search"
        view.backgroundColor = .systemBackground
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
    }
    
}

extension SearchViewController:UISearchBarDelegate, UISearchResultsUpdating {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let resultsController = searchController.searchResultsController as? SearchResultsViewController,
              let query = searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
        
        resultsController.delegate = self
        
        ApiManager.shared.searchUsers(with: query) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let users):
                    resultsController.update(with: users)
                case .failure(let error):
                    print(error)
                    resultsController.configureUI()
                }
            }
        }
        
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let resultsController = searchController.searchResultsController as? SearchResultsViewController else {
            return
        }
        
        resultsController.delegate = self
        
        guard let query = searchController.searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            resultsController.removeUserFromResults()
            resultsController.hideNoUserLabel()
            return
        }
        
        ApiManager.shared.searchUsers(with: query) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let users):
                    resultsController.update(with: users)
                case .failure(let error):
                    print(error)
                    resultsController.removeUserFromResults()
                    resultsController.configureUI()
                }
            }
        }
        
    }
    
}

extension SearchViewController:SearchResultsViewControllerDelegate {
    
    func searchResultsViewControllerDidSelectUser(_ result: User) {
        let vc = ProfileViewController(userId:result._id)
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
