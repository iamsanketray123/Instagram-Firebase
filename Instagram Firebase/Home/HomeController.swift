//
//  HomeController.swift
//  Instagram Firebase
//
//  Created by Sanket  Ray on 21/01/18.
//  Copyright © 2018 Sanket  Ray. All rights reserved.
//

import UIKit
import Firebase

class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout, HomePostCellDelegate{
    
    let cellId = "cellId"
    var posts = [Post]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleUpdateFeed), name: SharePhotoController.updateFeedNotificationName , object: nil)
        
        collectionView?.backgroundColor = .white
        collectionView?.register(HomePostCell.self, forCellWithReuseIdentifier: cellId)
        setupNavigationItems()
        
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView?.refreshControl = refreshControl
        
        fetchAllPosts()
    }
    @objc func handleUpdateFeed() {
        handleRefresh()
    }
    fileprivate func fetchAllPosts() {
        fetchPosts()
        fetchFollowingUserIds()
    }
    @objc func handleRefresh() {
        posts.removeAll()
        collectionView?.reloadData()
        fetchAllPosts()
    }
    fileprivate func fetchFollowingUserIds() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Database.database().reference().child("following").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            guard let userIdsDictionaries = snapshot.value as? [String: Any] else { return }
            userIdsDictionaries.forEach({ (key, value) in
                Database.fetchUserWithUID(uid: key, completion: { (user) in
                    self.fetchPostsWithUser(user: user)
                })
            })
        }) { (err) in
            print("Failed to get followed users:", err)
        }
    }
    fileprivate func fetchPosts() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Database.fetchUserWithUID(uid: uid) { (user) in
            self.fetchPostsWithUser(user: user)
        }
    }
    fileprivate func fetchPostsWithUser(user: User) {
        let ref = Database.database().reference().child("posts").child(user.uid)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            self.collectionView?.refreshControl?.endRefreshing()
            guard let dictionaries = snapshot.value as? [String: Any ] else { return }
            dictionaries.forEach({ (key, value) in
                guard let dictionary = value as? [String: Any] else { return }
                
                var post = Post(user: user, dictionary: dictionary)
                post.id = key
                self.posts.append(post)
            })
            self.posts.sort(by: { (p1, p2) -> Bool in
                return p1.creationDate.compare(p2.creationDate) == .orderedDescending
            })
            self.collectionView?.reloadData()
        }) { (err) in
            print("Failed to fetch posts from DB:", err)
        }
    }
    func setupNavigationItems() {
        navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "logo2"))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "camera3").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleCamera))
    }
    
    @objc func handleCamera(){
        let cameraController = CameraController()
        present(cameraController, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height : CGFloat = 40 + 8 + 8 //username and userpfoileimageview
        height += view.frame.width
        height += 50
        height += 60
        
        return CGSize(width: view.frame.width, height: height)
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! HomePostCell
        cell.post = posts[indexPath.item]
        cell.delegate = self
        return cell
    }
    func didTapComment(post: Post) {
        print(post.caption)
        let commentsController = CommentsController(collectionViewLayout: UICollectionViewFlowLayout())
        commentsController.post = post
        navigationController?.pushViewController(commentsController, animated: true)
    }
}
