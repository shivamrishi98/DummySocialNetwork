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
    private var profilePictureRequest:ProfilePictureRequest?
    
    private let scrollView:UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    private let profileImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .label
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        let layer = imageView.layer
        layer.borderWidth = 1
        layer.borderColor = UIColor.label.cgColor
        return imageView
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
        textfield.backgroundColor = .systemBackground
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
        textfield.backgroundColor = .systemBackground
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
        scrollView.addSubview(profileImageView)
        scrollView.addSubview(nameTextfield)
        scrollView.addSubview(emailTextfield)
        
        scrollView.contentSize = CGSize(width: view.width,
                                        height: view.height)
        
        profileImageView.layer.masksToBounds = true
        profileImageView.layer.cornerRadius = 75
        
        let gesture = UITapGestureRecognizer(target: self,
                                             action: #selector(didTapSelectProfileImage))
        profileImageView.addGestureRecognizer(gesture)
        
        configureUI(user: user)
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel,
                                                           target: self,
                                                           action: #selector(didTapCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save,
                                                           target: self,
                                                           action: #selector(didTapSave))
        
    }
    
    @objc private func didTapSelectProfileImage() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true)
    }
    
    private func configureUI(user:User) {
        DispatchQueue.main.async { [weak self] in
            self?.nameTextfield.text = user.name
            self?.emailTextfield.text = user.email
            self?.profileImageView.sd_setImage(
                with: URL(string: user.profilePictureUrl ?? ""),
                placeholderImage: UIImage(systemName: "person"),
                completed: nil)
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
        
        profileImageView.frame = CGRect(x: view.width/2-75,
                                        y: view.safeAreaInsets.top + 10,
                                        width: 150,
                                        height: 150)
        
        nameTextfield.frame = CGRect(x: 50,
                                     y: profileImageView.bottom + 50,
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
                                               email: email,
                                               profilePictureUrl:user.profilePictureUrl ?? "")
        
        if let profilePictureRequest = self.profilePictureRequest {
            // If profile picture selected then call upload profile picture api
            ApiManager.shared.uploadProfilePicture(request: profilePictureRequest) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let response):
                        let newRequest = UpdateUserProfileRequest(
                            name: name,
                            email: email,
                            profilePictureUrl:response.imageUrl ?? "")
                        
                        ApiManager.shared.updateUserProfile(request: newRequest) { success in
                            DispatchQueue.main.async {
                                if success {
                                    self?.dismissVC()
                                }
                            }
                        }
                    case .failure(let error):
                        print(error)
                    }
                }
            }
            
        } else {
            ApiManager.shared.updateUserProfile(request: request) { [weak self] success in
                DispatchQueue.main.async {
                    if success {
                        self?.dismissVC()
                    }
                }
            }
            
        }
    }

    private func dismissVC() {
        DispatchQueue.main.async { [weak self] in
            self?.dismiss(animated: true, completion: {
                self?.saveCompletion?(true)
                NotificationCenter.default.post(name: .didNotifyProfileUpdate,
                                                object: nil,
                                                userInfo: nil)
            })
        }
    }
    
}

extension EditProfileViewController:UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        guard let image = info[.editedImage] as? UIImage,
              let imageData = image.jpegData(compressionQuality: 1),
              let imageUrl = info[.imageURL]as? URL,
              let fileName = imageUrl.pathComponents.last else {
            return
        }
   
        let mimeType = "image/\(imageUrl.pathExtension)"
        profileImageView.image = image
        
        self.profilePictureRequest = ProfilePictureRequest(fileName: fileName,
                                            mimeType: mimeType,
                                            imageData: imageData)
        
    }
    
}
