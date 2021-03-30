//
//  SearchUsersViewController.swift
//  DummySocialNetwork
//
//  Created by Shivam Rishi on 30/03/21.
//

import UIKit

class SearchViewController: UIViewController {
    
    private let searchController:UISearchController = {
        let searchController = UISearchController(searchResultsController: SearchResultsViewController())
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
        
        ApiManager.shared.searchUsers(request: query) { result in
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
        
        guard let query = searchController.searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            resultsController.removeUserFromResults()
            resultsController.hideNoUserLabel()
            return
        }
        
        ApiManager.shared.searchUsers(request: query) { result in
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
    
}


