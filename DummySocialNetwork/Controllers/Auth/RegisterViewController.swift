//
//  RegisterViewController.swift
//  DummySocialNetwork
//
//  Created by Shivam Rishi on 27/03/21.
//

import UIKit

final class RegisterViewController: UIViewController {

    private let scrollView:UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    private let titleLabel:UILabel = {
        let label = UILabel()
        label.text = "Social Network"
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 42, weight: .semibold)
        return label
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
    
    private let passwordTextfield:UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Password..."
        textfield.textColor = .label
        textfield.autocapitalizationType = .none
        textfield.autocorrectionType = .no
        textfield.returnKeyType = .default
        textfield.isSecureTextEntry = true
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
    
    private let registerButton:UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemBlue
        button.setTitle("Register", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 12
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Register"
        view.addSubview(scrollView)
        scrollView.addSubview(titleLabel)
        scrollView.addSubview(nameTextfield)
        scrollView.addSubview(emailTextfield)
        scrollView.addSubview(passwordTextfield)
        scrollView.addSubview(registerButton)
        scrollView.contentSize = CGSize(width: view.width,
                                        height: view.height)
        
        registerButton.addTarget(self,
                              action: #selector(didTapRegister),
                              for: .touchUpInside)
    }
    
    @objc private func didTapRegister() {
        
        guard let name = nameTextfield.text,
              let email = emailTextfield.text,
              let password = passwordTextfield.text else {
            return
        }
        
        let request = RegisterRequest(name: name,
                                      email: email,
                                      password: password)
        
        AuthManager.shared.createAccount(request: request) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    AuthManager.shared.cacheToken(token: response.access_token)
                    let vc = TabViewController()
                    vc.modalPresentationStyle = .fullScreen
                    self?.present(vc, animated: true)
                case .failure(let error):
                    print(error)
                }
            }
        }
        
        
    }

    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        scrollView.frame = CGRect(x: 0,
                                  y: 0,
                                  width: view.width,
                                  height: view.height)
        
        titleLabel.frame = CGRect(x: 20,
                                  y: 50,
                                  width: view.width-40,
                                  height: 40)
        nameTextfield.frame = CGRect(x: 50,
                                      y:titleLabel.bottom + 50,
                                      width: view.width-100,
                                      height: 44)
        
        emailTextfield.frame = CGRect(x: 50,
                                      y:nameTextfield.bottom + 20,
                                      width: view.width-100,
                                      height: 44)
        
        passwordTextfield.frame = CGRect(x: 50,
                                         y: emailTextfield.bottom + 20,
                                      width: view.width-100,
                                      height: 44)
        
        registerButton.frame = CGRect(x: 50,
                                   y: passwordTextfield.bottom + 40,
                                   width: view.width-100,
                                   height: 44)
        
        
    }


}
