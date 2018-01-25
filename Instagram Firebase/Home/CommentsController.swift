//
//  CommentsController.swift
//  Instagram Firebase
//
//  Created by Sanket  Ray on 24/01/18.
//  Copyright © 2018 Sanket  Ray. All rights reserved.
//

import UIKit
import Firebase

class CommentsController: UICollectionViewController {
    var post : Post?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Comments"
        collectionView?.backgroundColor = .red
    }
    let commentTextField : UITextField = {
       let textField = UITextField()
        textField.placeholder = "Enter Comment"
        return textField
    }()
    lazy var containerView : UIView = {
        let containerView = UIView()
        containerView.backgroundColor = .gray
        containerView.frame = CGRect(x: 0, y: 0, width: 100, height: 50)
        
        let submitButton = UIButton(type: .system)
        submitButton.setTitle("Submit", for: .normal)
        submitButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        submitButton.setTitleColor(.black, for: .normal)
        submitButton.addTarget(self, action: #selector(handleSubmit), for: .touchUpInside)
        
        containerView.addSubview(submitButton)
        submitButton.anchor(top: containerView.topAnchor, left: nil, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 12, width: 50, height: 0)
        
        containerView.addSubview(commentTextField)
        commentTextField.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: submitButton.leftAnchor, paddingTop: 0, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        return containerView
    }()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    override var inputAccessoryView: UIView? {
        get{
            return containerView
        }
    }
    @objc func handleSubmit() {
        guard let comment = commentTextField.text else { return }
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let values = ["text": comment, "creationDate": Date().timeIntervalSince1970, "uid" : uid] as [String: Any]
        guard let postId = self.post?.id else { return }
        Database.database().reference().child("comments").child(postId).childByAutoId().updateChildValues(values) { (err, ref) in
            if let err = err {
                print("Failed to insert comments:", err)
                return
            }
            print("Successfully inseted comment")
        }
    }
    override var canBecomeFirstResponder: Bool {
        return true
    }
}












