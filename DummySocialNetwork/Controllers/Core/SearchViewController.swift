//
//  SearchUsersViewController.swift
//  DummySocialNetwork
//
//  Created by Shivam Rishi on 30/03/21.
//

import UIKit

class SearchViewController: UIViewController {
    
    private var users = [User]()
    private var sections = [String]()
    
    private let searchController:UISearchController = {
        let searchController = UISearchController(
            searchResultsController: SearchResultsViewController())
        searchController.searchBar.placeholder = "Search Users..."
        searchController.searchBar.searchBarStyle = .minimal
        searchController.definesPresentationContext = true
        return searchController
    }()
    
    private let refreshControl:UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        return refreshControl
    }()
    
    
    private let collectionView:UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewCompositionalLayout(
                sectionProvider: { section, _ -> NSCollectionLayoutSection? in
                    return SearchViewController.createSectionLayout(section: section)
                }))
        collectionView.backgroundColor = .systemBackground
        collectionView.register(
            RecommendedUsersCollectionViewCell.self,
            forCellWithReuseIdentifier: RecommendedUsersCollectionViewCell.identifier)
        collectionView.register(
            RecommendedUsersHeaderCollectionReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: RecommendedUsersHeaderCollectionReusableView.identifier)
        return collectionView
    }()
    
    private static func createSectionLayout(section:Int) -> NSCollectionLayoutSection {
        
        let supplementaryViews = [
            NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                   heightDimension: .absolute(50)),
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            )
        ]
        
        switch section {
        
        case 0:
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                  heightDimension: .fractionalHeight(1))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 2,
                                                         leading: 2,
                                                         bottom: 2,
                                                         trailing: 2)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                   heightDimension: .absolute(100))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                           subitem: item,
                                                           count: 5)
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuous
            section.boundarySupplementaryItems = supplementaryViews
            return section
        default:
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                  heightDimension: .fractionalHeight(1))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(50),
                                                   heightDimension: .absolute(50))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                           subitem: item,
                                                           count: 1)
            let section = NSCollectionLayoutSection(group: group)
            return section
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search"
        view.backgroundColor = .systemBackground
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        fetchData()
    }
    
    @objc private func didPullToRefresh() {
        DispatchQueue.main.async { [weak self] in
            self?.fetchData()
            self?.refreshControl.endRefreshing()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        collectionView.frame = view.bounds
        
    }
    
    private func fetchData() {
       
        let group = DispatchGroup()
        group.enter()
       
        ApiManager.shared.getRecommendedUsers { [weak self] result in
            defer {
                group.leave()
            }
            DispatchQueue.main.async {
                self?.sections.removeAll()
                switch result {
                case .success(let users):
                    self?.users = users
                    self?.configureSections()
                case .failure(let error):
                    print(error)
                }
            }
        }
        
        group.notify(queue: .main) { [weak self] in
            self?.collectionView.reloadData()
            self?.refreshControl.endRefreshing()
        }
        
    }
    
    private func configureSections() {
        if !users.isEmpty {
            sections.append("Recommended Users")
        }
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
        let vc = ProfileViewController(user: result)
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension SearchViewController:UICollectionViewDelegate,UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return users.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: RecommendedUsersCollectionViewCell.identifier,
                for: indexPath) as? RecommendedUsersCollectionViewCell else {
            return UICollectionViewCell()
        }
        let model = users[indexPath.row]
        let viewModel = RecommendedUsersViewModel(
            name: model.name,
            profilePictureUrl: URL(string: model.profilePictureUrl ?? ""))
        cell.configure(with: viewModel)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard kind == UICollectionView.elementKindSectionHeader,
              let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: RecommendedUsersHeaderCollectionReusableView.identifier,
                for: indexPath) as? RecommendedUsersHeaderCollectionReusableView else {
            return UICollectionReusableView()
        }
        
        let section = sections[indexPath.section]
        header.configure(with: section)
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch indexPath.section {
        case 0:
            let user = users[indexPath.row]
            let vc = ProfileViewController(user: user)
            navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
        
    }
    
}
