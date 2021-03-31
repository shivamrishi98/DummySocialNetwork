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
        
       configureSections()
        
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

    private func configureSections() {
        
        // Security
        sections.append(
            SettingsSectionViewModel(
                title: "Security",
                option: [
                    SettingsViewModel(
                        viewModelType: .changePassword,
                        title: "Change Password",
                        handler: { [weak self] in
                            self?.showChangePasswordAlert()
                        })
                ]))
        
        
        // Logout
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
    }
    
    private func showChangePasswordAlert() {
        let alert = UIAlertController(title: "Change Password",
                                      message: nil,
                                      preferredStyle: .alert)
        
        alert.addTextField { texfield in
            texfield.placeholder = "Old Password..."
            texfield.isSecureTextEntry = true
        }
        
        alert.addTextField { texfield in
            texfield.placeholder = "New Password..."
            texfield.isSecureTextEntry = true
        }
        
        alert.addAction(
            UIAlertAction(
                title: "Change",
                style: .default,
                handler: { _ in
                    guard let oldpasswordField = alert.textFields?.first,
                          let newpasswordField = alert.textFields?.last,
                          let oldpassword = oldpasswordField.text,
                          let newpassword = newpasswordField.text,
                          !oldpassword.trimmingCharacters(in: .whitespaces).isEmpty,
                          !newpassword.trimmingCharacters(in: .whitespaces).isEmpty else {
                        return
                    }
                    
                    let request = ChangePasswordRequest(oldpassword: oldpassword,
                                                        newpassword: newpassword)
                    AuthManager.shared.changePassword(request: request) { [weak self] success in
                        DispatchQueue.main.async {
                            if success {
                                let alert = UIAlertController(title: "Password Changed Successfully",
                                                              message: nil,
                                                              preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "Okay",
                                                              style: .cancel,
                                                              handler: nil))
                                self?.present(alert, animated: true)
                            }
                        }
                    }
                    
                    
                }))
        
        alert.addAction(UIAlertAction(title: "Cancel",
                                      style: .cancel,
                                      handler: nil))
        present(alert, animated: true)
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
        
        switch viewModel.viewModelType {
        case .changePassword:
            cell.textLabel?.textColor = .label
        case .logout:
            cell.textLabel?.textColor = .systemRed
            cell.textLabel?.textAlignment = .center
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        sections[indexPath.section].option[indexPath.row].handler?()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let viewModel = sections[section]
        return viewModel.title
    }
    
}
