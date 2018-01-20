//
//  SharePhotoController.swift
//  Instagram Firebase
//
//  Created by Sanket  Ray on 20/01/18.
//  Copyright © 2018 Sanket  Ray. All rights reserved.
//

import UIKit

class SharePhotoController: UIViewController {

    var selectedImage : UIImage? {
        didSet{
            imageView.image = selectedImage
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.rgb(240, 240, 240)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(handleShare))

        setupImageAndTextViews()
    }
    let imageView : UIImageView = {
       let iv = UIImageView()
        iv.backgroundColor = .white
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    let textView : UITextView = {
       let tv = UITextView()
        tv.backgroundColor = UIColor(white: 0, alpha: 0.04)
        return tv
    }()
    
    fileprivate func setupImageAndTextViews() {
        let containerView = UIView()
        containerView.backgroundColor = .white
        view.addSubview(containerView)
        containerView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 100)
        
        containerView.addSubview(imageView)
        imageView.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: 8, paddingRight: 0, width: 84, height: 0)
        
        containerView.addSubview(textView)
        textView.anchor(top: containerView.topAnchor, left: imageView.rightAnchor, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    @objc func handleShare(){
        
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
