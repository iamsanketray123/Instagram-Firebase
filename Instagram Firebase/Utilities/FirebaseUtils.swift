//
//  FirebaseUtils.swift
//  Instagram Firebase
//
//  Created by Sanket  Ray on 21/01/18.
//  Copyright © 2018 Sanket  Ray. All rights reserved.
//

import UIKit
import Firebase

extension Database {
    static func fetchUserWithUID(uid: String, completion : @escaping (User)->()) {
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            let user = User(uid: uid, dictionary: dictionary)
            
            completion(user)
        }) { (err) in
            print("Failed to fetch user:", err)
        }
    }
}
