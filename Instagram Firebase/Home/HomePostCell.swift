//
//  HomePostCell.swift
//  Instagram Firebase
//
//  Created by Sanket  Ray on 21/01/18.
//  Copyright © 2018 Sanket  Ray. All rights reserved.
//

import UIKit

protocol HomePostCellDelegate {
    func didTapComment(post : Post)
    func didLike(for cell: HomePostCell)
}

class HomePostCell : UICollectionViewCell {
 
    var delegate : HomePostCellDelegate?
    
    var post: Post? {
        didSet {
            guard let url = post?.imageUrl else { return }
            photoImageView.loadImage(urlString: url)
            likeButton.setImage(post?.hasLiked == true ? #imageLiteral(resourceName: "like_selected").withRenderingMode(.alwaysOriginal) : #imageLiteral(resourceName: "like_unselected").withRenderingMode(.alwaysOriginal), for: .normal)
            
            usernameLabel.text = post?.user.username
            guard let profileImageUrl = post?.user.profileImageUrl else { return }
            userProfileImageView.loadImage(urlString: profileImageUrl)
            
            setupAttributedCaption()
        }
    }
    fileprivate func setupAttributedCaption() {
        guard let post = self.post else { return }
        
        let attributedText = NSMutableAttributedString(string: post.user.username, attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: "  \(post.caption)", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14)]))
        attributedText.append(NSAttributedString(string: "\n\n", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 4)]))
        let timeAgoDisplay = post.creationDate.timeAgoDisplay()
        attributedText.append(NSAttributedString(string: timeAgoDisplay, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: UIColor.gray]))
        captionLabel.attributedText = attributedText
    }
    let photoImageView: CustomImageView = {
       let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    let userProfileImageView : CustomImageView = {
       let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    let usernameLabel : UILabel = {
       let label = UILabel()
        label.text = "Username"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    let optionsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("•••", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    lazy var likeButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "like_unselected").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleLike), for: .touchUpInside)
        return button
    }()
    @objc func handleLike() {
        delegate?.didLike(for: self)
    }
//    Need to use lazy var here else addTarget method wont work 🤔
    lazy var commentButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "comment").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleComment), for: .touchUpInside)
        return button
    }()
    @objc func handleComment() {
        guard let post = self.post else { return }
        delegate?.didTapComment(post: post)
    }
    let sendMessageButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "send2").withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    let bookmarkButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "ribbon").withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    let captionLabel : UILabel = {
       let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
    
        addSubview(photoImageView)
        addSubview(userProfileImageView)
        addSubview(usernameLabel)
        addSubview(optionsButton)
        
        userProfileImageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 40, height: 40)
        userProfileImageView.layer.cornerRadius = 40 / 2
        photoImageView.anchor(top: userProfileImageView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        photoImageView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1).isActive = true
        usernameLabel.anchor(top: topAnchor, left: userProfileImageView.rightAnchor, bottom: photoImageView.topAnchor, right: optionsButton.rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        optionsButton.anchor(top: topAnchor, left: nil, bottom: photoImageView.topAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 44, height: 0)
        
        setupActionButton()
        addSubview(captionLabel)
        captionLabel.anchor(top: likeButton.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 0)
    }
    fileprivate func setupActionButton() {
        let stackView = UIStackView(arrangedSubviews: [likeButton,commentButton,sendMessageButton])
        stackView.distribution = .fillEqually
        
        addSubview(bookmarkButton)
        addSubview(stackView)
        stackView.anchor(top: photoImageView.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 120, height: 50)
        bookmarkButton.anchor(top: photoImageView.bottomAnchor, left: nil, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 40, height: 50)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}














