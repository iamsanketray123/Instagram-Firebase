//
//  CommentsController.swift
//  Instagram Firebase
//
//  Created by Sanket  Ray on 24/01/18.
//  Copyright © 2018 Sanket  Ray. All rights reserved.
//

import UIKit
import Firebase

class CommentsController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    var post : Post?
    let cellId = "cellId"
    var comments = [Comment]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Comments"
        collectionView?.backgroundColor = .white
//        Don't need the following lines
//        collectionView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: -50, right: 0)
//        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: -50, right: 0)
        collectionView?.alwaysBounceVertical = true
        collectionView?.keyboardDismissMode = .interactive
        collectionView?.register(CommentCell.self, forCellWithReuseIdentifier: cellId)
        fetchComments()
    }
    fileprivate func fetchComments() {
        guard let postId = post?.id else { return }
        let ref = Database.database().reference().child("comments").child(postId)
        ref.observe(.childAdded, with: { (snapshot) in
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            
            guard let uid = dictionary["uid"] as? String else { return }
            Database.fetchUserWithUID(uid: uid, completion: { (user) in
                let comment = Comment(user: user,dictionary: dictionary)
                self.comments.append(comment)
                self.collectionView?.reloadData()
            })
        }) { (err) in
            print("Failed to fetch comments:", err)
        }
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comments.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CommentCell
        cell.comment = comments[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//      Creating dymanic cells. Check code properly
        
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        let dummyCell = CommentCell(frame: frame)
        dummyCell.comment = comments[indexPath.item]
        dummyCell.layoutIfNeeded()
        let targetSize = CGSize(width: view.frame.width, height: 1000)
        let estimatedSize = dummyCell.systemLayoutSizeFitting(targetSize)
        let height = max(40 + 8 + 8, estimatedSize.height)
        
        return CGSize(width: view.frame.width, height: height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    let commentTextField : UITextField = {
       let textField = UITextField()
        textField.placeholder = "Enter Comment"
        return textField
    }()
    lazy var containerView : UIView = {
        let containerView = UIView()
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
        
        let lineSeparatorView = UIView()
        lineSeparatorView.backgroundColor = UIColor.rgb(230,230,230)
        
        containerView.addSubview(lineSeparatorView)
        lineSeparatorView.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: nil, right: containerView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 1)
        
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












