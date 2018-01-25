//
//  UserProfileHeader.swift
//  Instagram Firebase
//
//  Created by Sanket  Ray on 19/01/18.
//  Copyright © 2018 Sanket  Ray. All rights reserved.
//

import UIKit
import Firebase

protocol UserProfileHeaderDelegate {
    func didChangeToListView()
    func didChangeToGridView()
}

class UserProfileHeader : UICollectionViewCell {
    
    var delegate: UserProfileHeaderDelegate?
    
    var user: User? {
        didSet{
            guard let profileImageUrl = user?.profileImageUrl else { return }
            profileImageView.loadImage(urlString: profileImageUrl)
            //            setupProfileImage()
            usernameLabel.text = user?.username
            
            setupEditFollowButton()
        }
    }
    
    fileprivate func setupEditFollowButton() {
        guard let currentLoggedInUserId = Auth.auth().currentUser?.uid else { return }
        guard let userId = user?.uid else { return }
        if currentLoggedInUserId == userId {
            // edit profile
            
        } else {
            // check if already following
            Database.database().reference().child("following").child(currentLoggedInUserId).child(userId).observeSingleEvent(of: .value, with: { (snapshot) in
                if let isFollowing = snapshot.value as? Int, isFollowing == 1 {
                    self.editProfileFollowButton.setTitle("Unfollow", for: .normal)
                }else {
                   self.setupFollowStyle()
                }
            }, withCancel: { (err) in
                print("Failed to check if you are following the user:", err)
            })
            
            
        }
    }
    @objc func handleEditProfileOrFollow() {
        
        guard let currentLoggedInUserId = Auth.auth().currentUser?.uid else { return }
        guard let userId = user?.uid else { return }
        
        if editProfileFollowButton.titleLabel?.text == "Unfollow" {
            //            unfollow
            Database.database().reference().child("following").child(currentLoggedInUserId).child(userId).removeValue(completionBlock: { (err, ref) in
                if let err = err {
                    print("Failed to unfollow user:", err)
                    return
                }
                print("Successfully unfollwed user")
                self.setupFollowStyle()
                
            })
        } else {
            //            follow
            let ref = Database.database().reference().child("following").child(currentLoggedInUserId)
            let values = [userId: 1]
            ref.updateChildValues(values) { (err, ref) in
                if let err = err {
                    print("Failed to follow user:", err)
                    return
                }
                print("Successfully followed user:", self.user?.username ?? "")
                self.editProfileFollowButton.setTitle("Unfollow", for: .normal)
                self.editProfileFollowButton.backgroundColor = .white
                self.editProfileFollowButton.setTitleColor(.black, for: .normal)
            }
            
        }
    }
    
    fileprivate func setupFollowStyle() {
        self.editProfileFollowButton.setTitleColor(.white, for: .normal)
        self.editProfileFollowButton.backgroundColor = UIColor.rgb(17,154,237)
        self.editProfileFollowButton.layer.borderColor = UIColor(white: 0, alpha: 0.2).cgColor
        self.editProfileFollowButton.setTitle("Follow", for: .normal)
    }
    let profileImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.layer.borderColor = UIColor.lightGray.cgColor
        iv.layer.borderWidth = 0.2
        return iv
    }()
    lazy var gridButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "grid"), for: .normal)
        button.tintColor = UIColor.mainBlue()
        button.addTarget(self, action: #selector(handleChangeToGridView), for: .touchUpInside)
        return button
    }()
    @objc func handleChangeToGridView() {
        gridButton.tintColor = .mainBlue()
        listButton.tintColor = UIColor(white: 0, alpha: 0.2)
        delegate?.didChangeToGridView()
    }
    lazy var listButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "list"), for: .normal)
        button.tintColor = UIColor(white: 0, alpha: 0.2)
        button.addTarget(self, action: #selector(handleChangeToListView), for: .touchUpInside)
        return button
    }()
    @objc func handleChangeToListView() {
        gridButton.tintColor = UIColor(white: 0, alpha: 0.2)
        listButton.tintColor = .mainBlue()
        delegate?.didChangeToListView()
    }
    let bookmarkButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "ribbon"), for: .normal)
        button.tintColor = UIColor(white: 0, alpha: 0.2)
        return button
    }()
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    let postLabel : UILabel = {
        let label = UILabel()
        let attributedText = NSMutableAttributedString(string: "11\n", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: "posts", attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14)]))
        label.attributedText = attributedText
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    let followersLabel : UILabel = {
        let label = UILabel()
        let attributedText = NSMutableAttributedString(string: "0\n", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: "followers", attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14)]))
        label.attributedText = attributedText
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    let followingLabel : UILabel = {
        let label = UILabel()
        let attributedText = NSMutableAttributedString(string: "0\n", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: "following", attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14)]))
        label.attributedText = attributedText
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    lazy var editProfileFollowButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Edit Profile", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 3
        button.addTarget(self, action: #selector(handleEditProfileOrFollow), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 12, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 80, height: 80)
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = 80 / 2
        
        setupBottomToolbar()
        
        addSubview(usernameLabel)
        usernameLabel.anchor(top: profileImageView.bottomAnchor, left: leftAnchor, bottom: gridButton.topAnchor, right: rightAnchor, paddingTop: 4, paddingLeft: 12, paddingBottom: 0, paddingRight: 12, width: 0, height: 0)
        
        setupUserStatsView()
        
        addSubview(editProfileFollowButton)
        editProfileFollowButton.anchor(top: postLabel.bottomAnchor, left: postLabel.leftAnchor, bottom: nil, right: followingLabel.rightAnchor, paddingTop: 2, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 34)
    }
    fileprivate func setupUserStatsView(){
        let stackView = UIStackView(arrangedSubviews: [postLabel,followersLabel,followingLabel])
        stackView.backgroundColor = .gray
        addSubview(stackView)
        stackView.distribution = .fillEqually
        
        stackView.anchor(top: topAnchor, left: profileImageView.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: 12, paddingLeft: 12, paddingBottom: 0, paddingRight: 12, width: 0, height: 50)
    }
    
    fileprivate func setupBottomToolbar(){
        let topDividerView = UIView()
        topDividerView.backgroundColor = .lightGray
        let bottomDividerView = UIView()
        bottomDividerView.backgroundColor = .lightGray
        let stackView = UIStackView(arrangedSubviews: [gridButton,listButton,bookmarkButton])
        
        addSubview(stackView)
        addSubview(topDividerView)
        addSubview(bottomDividerView)
        
        stackView.distribution = .fillEqually
        stackView.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
        
        topDividerView.anchor(top: stackView.topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
        bottomDividerView.anchor(top: nil, left: leftAnchor, bottom: stackView.bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //    fileprivate func setupProfileImage() {
    //        guard let profileImageUrl = user?.profileImageUrl else { return }
    //        guard let url = URL(string: profileImageUrl) else { return }
    //        URLSession.shared.dataTask(with: url) { (data, response, error) in
    //            if let error = error {
    //                print("Error downloading image from Firebase:", error)
    //                return
    //            }
    //            guard let data = data else { return }
    //            DispatchQueue.main.async {
    //                self.profileImageView.image = UIImage(data: data)
    //            }
    //        }.resume()
    //    }
}











