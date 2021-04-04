//
//  CreatePostViewController.swift
//  DummySocialNetwork
//
//  Created by Shivam Rishi on 29/03/21.
//

import UIKit

class CreatePostViewController: UIViewController {

    var createPostCompletion:((Bool)->Void)?
    private var imageRequestModel:ImageRequestModel?
    
    private let scrollView:UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    private let captionTextView:UITextView = {
        let textView = UITextView()
        textView.isHidden = true
        textView.text = "Write caption..."
        textView.textColor = .lightGray
        textView.font = .systemFont(ofSize: 18)
        let layer = textView.layer
        layer.borderWidth = 1
        layer.borderColor = UIColor.label.cgColor
        layer.masksToBounds = true
        layer.cornerRadius = 1
        return textView
    }()
    
    private let imageView:UIImageView = {
        let imageView = UIImageView()
        imageView.isHidden = true
        imageView.tintColor = .label
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Create Post"
        view.backgroundColor = .secondarySystemBackground
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(captionTextView)
        captionTextView.delegate = self
        
        scrollView.contentSize = CGSize(width: view.width,
                                        height: view.height)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel,
                                                           target: self,
                                                           action: #selector(didTapCancel))
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image:UIImage(systemName: "photo"),
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(didTapSelectPhoto))
        
    }
    
    @objc private func didTapSelectPhoto() {
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    @objc private func didTapCreate() {
        
        guard let caption = captionTextView.text,
              !caption.trimmingCharacters(in: .whitespaces).isEmpty,
              caption != "Write caption...",
              let imageRequestModel = imageRequestModel else {
            return
        }
        
        let request = CreatePostRequest(caption: caption,
                                        fileName: imageRequestModel.fileName,
                                        mimeType: imageRequestModel.mimeType,
                                        imageData: imageRequestModel.imageData)
        
        ApiManager.shared.createPost(request: request) { [weak self] success in
            DispatchQueue.main.async {
                if success {
                    self?.dismiss(animated: true, completion: {
                        self?.createPostCompletion?(true)
                    })
                }
            }
        }
    }
    
    @objc private func didTapCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        scrollView.frame = view.bounds
        
        imageView.frame = CGRect(x: 10,
                                       y: scrollView.top + 10,
                                       width: view.width-20,
                                       height: view.height-view.safeAreaInsets.top-400)
        
        
        captionTextView.frame = CGRect(x: 10,
                                       y: imageView.bottom + 5,
                                       width: view.width-20,
                                       height: view.height-view.safeAreaInsets.top-imageView.height-60)
        
    }

}

extension CreatePostViewController:UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if !textView.text.isEmpty {
            textView.text = nil
            textView.textColor = .label
        }
    }
    
    
}

extension CreatePostViewController:UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    
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
        
        imageView.isHidden = false
        captionTextView.isHidden = false
        navigationItem.rightBarButtonItem = nil
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Create",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(didTapCreate))
        
        let mimeType = "image/\(imageUrl.pathExtension)"
        imageView.image = image
        
        imageRequestModel = ImageRequestModel(fileName: fileName,
                                            mimeType: mimeType,
                                            imageData: imageData)
        
    }
    
}


