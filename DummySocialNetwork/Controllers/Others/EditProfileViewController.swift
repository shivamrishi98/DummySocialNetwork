//
//  EditProfileViewController.swift
//  DummySocialNetwork
//
//  Created by Shivam Rishi on 28/03/21.
//

import UIKit

class EditProfileViewController: UIViewController {

    var saveCompletion:((Bool)->Void)?
    
    private let user:User
    
    
    private let scrollView:UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    private let nameTextfield:UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Name..."
        textfield.textColor = .label
        textfield.autocapitalizationType = .none
        textfield.autocorrectionType = .no
        textfield.returnKeyType = .continue
        textfield.leftView = UIView(frame: CGRect(x: 0,
                                            y: 0,
                                            width: 5,
                                            height: 0))
        textfield.leftViewMode = .always
        textfield.backgroundColor = .secondarySystemBackground
        let layer = textfield.layer
        layer.borderWidth = 1
        layer.borderColor = UIColor.label.cgColor
        layer.masksToBounds = true
        layer.cornerRadius = 12
        return textfield
    }()
    
    private let emailTextfield:UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Email Address..."
        textfield.textColor = .label
        textfield.autocapitalizationType = .none
        textfield.autocorrectionType = .no
        textfield.returnKeyType = .continue
        textfield.leftView = UIView(frame: CGRect(x: 0,
                                            y: 0,
                                            width: 5,
                                            height: 0))
        textfield.leftViewMode = .always
        textfield.backgroundColor = .secondarySystemBackground
        let layer = textfield.layer
        layer.borderWidth = 1
        layer.borderColor = UIColor.label.cgColor
        layer.masksToBounds = true
        layer.cornerRadius = 12
        return textfield
    }()
        
    
    init(user:User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .secondarySystemBackground
        title = "Edit Profile"
        view.addSubview(scrollView)
        scrollView.addSubview(nameTextfield)
        scrollView.addSubview(emailTextfield)
        
        scrollView.contentSize = CGSize(width: view.width,
                                        height: view.height)
        
        configureUI(user: user)
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel,
                                                           target: self,
                                                           action: #selector(didTapCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save,
                                                           target: self,
                                                           action: #selector(didTapSave))
        
    }
    
    private func configureUI(user:User) {
        DispatchQueue.main.async { [weak self] in
            self?.nameTextfield.text = user.name
            self?.emailTextfield.text = user.email
        }
    }
    
    @objc private func didTapCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func didTapSave() {
        updateProfile()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        scrollView.frame = view.bounds
        
        nameTextfield.frame = CGRect(x: 50,
                                     y: view.safeAreaInsets.top + 50,
                                      width: view.width-100,
                                      height: 44)
        
        emailTextfield.frame = CGRect(x: 50,
                                      y: nameTextfield.bottom + 20,
                                      width: view.width-100,
                                      height: 44)
        
    }
    
    private func updateProfile() {
        guard let name = nameTextfield.text,
              let email = emailTextfield.text else {
            return
        }
        let request = UpdateUserProfileRequest(name: name,
                                               email: email)
        ApiManager.shared.updateUserProfile(request: request) { [weak self] success in
            DispatchQueue.main.async {
                if success {
                    self?.dismiss(animated: true, completion: {
                        self?.saveCompletion?(true)
                    })
                }
            }
        }
        
    }

}
