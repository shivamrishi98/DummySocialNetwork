//
//  CommentsViewController.swift
//  DummySocialNetwork
//
//  Created by Shivam Rishi on 04/04/21.
//

import UIKit

class CommentsViewController: UIViewController {

    private let postId:String
    private var comments = [Comment]()
    
    private let noCommentsLabel:UILabel = {
        let label = UILabel()
        label.text = "No Comments"
        label.isHidden = true
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        return label
    }()
    
    private let tableView:UITableView = {
         let tableView = UITableView()
        tableView.isHidden = true
        tableView.register(CommentTableViewCell.self,
                           forCellReuseIdentifier: CommentTableViewCell.identifier)
         return tableView
    }()
    
    private let footerView:UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemFill
        return view
    }()
    
    private let commentTextfield:UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Comment..."
        textfield.textColor = .label
        textfield.autocapitalizationType = .none
        textfield.autocorrectionType = .no
        textfield.returnKeyType = .continue
        textfield.leftView = UIView(frame: CGRect(x: 0,
                                            y: 0,
                                            width: 5,
                                            height: 0))
        textfield.leftViewMode = .always
        textfield.backgroundColor = .systemBackground
        let layer = textfield.layer
        layer.borderWidth = 1
        layer.borderColor = UIColor.label.cgColor
        layer.masksToBounds = true
        layer.cornerRadius = 12
        return textfield
    }()
    
    private let commentButton:UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .systemBlue
        button.setTitle("Comment", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 12
        return button
    }()
    
    init(postId:String) {
        self.postId = postId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Comments"
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        view.addSubview(footerView)
        view.addSubview(noCommentsLabel)
        footerView.addSubview(commentTextfield)
        footerView.addSubview(commentButton)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsHorizontalScrollIndicator = false

        fetchData()
        
        commentButton.addTarget(self,
                                action: #selector(didTapCommentButton),
                                for: .touchUpInside)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleKeyboardNotification(_:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleKeyboardNotification(_:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleKeyboardNotification(_:)),
                                               name: UIResponder.keyboardWillChangeFrameNotification,
                                               object: nil)
        
    }
    
    @objc private func didTapCommentButton() {
        
        guard let comment = commentTextfield.text,
              !comment.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
        
        let request = CreateCommentRequest(comment: comment)
        
        ApiManager.shared.commentOnPost(with: postId,
                                        request: request) { [weak self] success in
            DispatchQueue.main.async {
                if success {
                    self?.commentTextfield.text = nil
                    self?.fetchData()
                }
            }
        }
        
    }
    
    @objc private func handleKeyboardNotification(_ notification:Notification) {

        guard let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        
        if notification.name == UIResponder.keyboardWillShowNotification ||  notification.name == UIResponder.keyboardWillChangeFrameNotification {
                footerView.frame.origin.y = keyboardRect.height+180
        }else{
                footerView.frame.origin.y = view.bottom-view.safeAreaInsets.bottom-60
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.frame = CGRect(x: 0,
                                 y: 0,
                                 width: view.width,
                                 height: view.height-150)
        
        footerView.frame = CGRect(x: 0,
                                  y: view.bottom-view.safeAreaInsets.bottom-60,
                                  width: view.width,
                                  height: 60)
        
        commentTextfield.frame = CGRect(x: 5,
                                        y: 5,
                                        width: footerView.width*0.75-10,
                                        height: 44)
        
        commentButton.frame = CGRect(x: commentTextfield.right + 2,
                                        y: 5,
                                        width: footerView.width-commentTextfield.width-12,
                                        height: 44)
        
        noCommentsLabel.frame = CGRect(x: 0,
                                    y: 0,
                                    width: view.width,
                                    height: 50)
        noCommentsLabel.center = view.center
        
        
        
    }
    
    private func configureUI() {

        if comments.isEmpty {
            noCommentsLabel.isHidden = false
            tableView.isHidden = true
        } else {
            noCommentsLabel.isHidden = true
            tableView.isHidden = false
        }
        tableView.reloadData()
    }
    
    private func fetchData() {
        comments.removeAll()
        ApiManager.shared.getComments(with: postId) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let comments):
                    self?.comments = comments
                    self?.configureUI()
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
}

extension CommentsViewController:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
                withIdentifier: CommentTableViewCell.identifier,
                for: indexPath) as? CommentTableViewCell else {
            return UITableViewCell()
        }
        let model = comments[indexPath.row]
        let viewModel = CommentViewModel(
            name: model.commentedBy.name,
            comment: model.comment,
            profilePictureUrl: URL(string: model.commentedBy.profilePictureUrl ?? ""),
            createdDate: String.formattedDate(string: model.createdDate))
        cell.configure(with: viewModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        
        guard let userId = UserDefaults.standard.value(forKey: "userId") as? String else {
            return .none
        }
        
        let loggedInUser = comments[indexPath.row].commentedBy.userId == userId
        
        if loggedInUser {
            return .delete
        }
        
        return .none
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        guard let userId = UserDefaults.standard.value(forKey: "userId") as? String else {
            return
        }
        
        let loggedInUser = comments[indexPath.row].commentedBy.userId == userId
        let model = comments[indexPath.row]
        if loggedInUser {
            
            if editingStyle == .delete {
                ApiManager.shared.deleteComment(with: postId,
                                                commentId: model._id) { [weak self] success in
                    DispatchQueue.main.async {
                        if success {
                            self?.fetchData()
                        }
                    }
                }
            }
        }
        
        
        
    }
    
}
