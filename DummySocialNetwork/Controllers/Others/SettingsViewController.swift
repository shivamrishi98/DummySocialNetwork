//
//  SettingsViewController.swift
//  DummySocialNetwork
//
//  Created by Shivam Rishi on 28/03/21.
//

import UIKit

class SettingsViewController: UIViewController {

    private var sections = [SettingsSectionViewModel]()
    
    private let tableView:UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: "cell")
       return tableView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Settings"
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        sections.append(
            SettingsSectionViewModel(
                title: "",
                option: [
                    SettingsViewModel(
                        viewModelType: .logout,
                        title: "Logout",
                        handler: {
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
                        })
                ]))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .close,
            target: self,
            action: #selector(didTapClose))
    }
    
    @objc private func didTapClose() {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }

}

extension SettingsViewController:UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].option.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let viewModel = sections[indexPath.section].option[indexPath.row]
        cell.textLabel?.text = viewModel.title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        sections[indexPath.section].option[indexPath.row].handler?()
    }
    
}
