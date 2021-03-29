//
//  CreatePostViewController.swift
//  DummySocialNetwork
//
//  Created by Shivam Rishi on 29/03/21.
//

import UIKit

class CreatePostViewController: UIViewController {

    var createPostCompletion:((Bool)->Void)?
    
    private let contentTextView:UITextView = {
        let textView = UITextView()
        textView.text = "Placeholder..."
        textView.textColor = .lightGray
        textView.font = .systemFont(ofSize: 18)
        let layer = textView.layer
        layer.borderWidth = 1
        layer.borderColor = UIColor.label.cgColor
        layer.masksToBounds = true
        layer.cornerRadius = 12
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Create Post"
        view.backgroundColor = .secondarySystemBackground
        view.addSubview(contentTextView)
        contentTextView.delegate = self
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel,
                                                           target: self,
                                                           action: #selector(didTapCancel))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Create",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(didTapCreate))
    }
    
    @objc private func didTapCreate() {
        
        guard let content = contentTextView.text,
              !content.trimmingCharacters(in: .whitespaces).isEmpty,
              content != "Placeholder..." else {
            return
        }
        
        let request = CreatePostRequest(content: content)
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
        
        contentTextView.frame = CGRect(x: 10,
                                       y: view.safeAreaInsets.top + 20,
                                       width: view.width-20,
                                       height: view.height-view.safeAreaInsets.top-200)
        
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
