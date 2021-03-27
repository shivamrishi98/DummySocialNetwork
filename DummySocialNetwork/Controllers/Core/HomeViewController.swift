//
//  HomeViewController.swift
//  DummySocialNetwork
//
//  Created by Shivam Rishi on 27/03/21.
//

import UIKit

final class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Home"
        view.backgroundColor = .systemBackground
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Log out",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(didTapLogout))
    }
    
    @objc private func didTapLogout() {
        AuthManager.shared.signOut { [weak self] success in
            DispatchQueue.main.async {
                if success {
                    let vc = LoginViewController()
                    let navVC = UINavigationController(rootViewController: vc)
                    navVC.modalPresentationStyle = .fullScreen
                    self?.present(navVC, animated: true)
                }
            }
        }
    }

}
