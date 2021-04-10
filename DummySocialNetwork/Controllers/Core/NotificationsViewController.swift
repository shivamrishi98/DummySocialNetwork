//
//  NotificationsViewController.swift
//  DummySocialNetwork
//
//  Created by Shivam Rishi on 09/04/21.
//

import UIKit

class NotificationsViewController: UIViewController {

    private var notifications = [UserNotification]()
    
    private let tableView:UITableView = {
       let tableView = UITableView()
       tableView.isHidden = true
       tableView.register(NotificationTableViewCell.self,
                          forCellReuseIdentifier: NotificationTableViewCell.identifier)
       return tableView
   }()
   
   private let noNotificationFoundLabel:UILabel = {
       let label = UILabel()
       label.isHidden = true
       label.textColor = .label
       label.textAlignment = .center
       label.font = .systemFont(ofSize: 18, weight: .semibold)
       return label
   }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Notifications"
        view.backgroundColor = .systemBackground
        
        view.addSubview(tableView)
        view.addSubview(noNotificationFoundLabel)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        
        fetchData()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.frame = view.bounds
        
        noNotificationFoundLabel.frame = CGRect(x: 0,
                                    y: 0,
                                    width: view.width,
                                    height: 50)
        noNotificationFoundLabel.center = view.center
        
    }
    
    private func configure() {
        if notifications.isEmpty {
            noNotificationFoundLabel.text = "No Notifications"
            noNotificationFoundLabel.isHidden = false
            tableView.isHidden = true
        } else {
            noNotificationFoundLabel.isHidden = true
            tableView.isHidden = false
        }
        tableView.reloadData()
    }
    
    private func fetchData() {
        ApiManager.shared.getAllNotifications { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let notifications):
                    self?.notifications = notifications
                    self?.configure()
                case .failure(let error):
                    print(error)
                }
            }
        }
    }

}

extension NotificationsViewController:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
                withIdentifier: NotificationTableViewCell.identifier, for: indexPath) as? NotificationTableViewCell else {
            return UITableViewCell()
        }
        let model = notifications[indexPath.row]
        let viewModel = NotificationViewModel(
            message: model.message,
            contentUrl: URL(string: model.contentUrl ?? ""),
            createdDate: String.formattedDate(string: model.createdDate, dateFormat: "d MMM hh:mm a"))
        cell.configure(with: viewModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
}
