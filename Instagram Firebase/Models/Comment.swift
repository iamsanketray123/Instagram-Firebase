//
//  Comment.swift
//  Instagram Firebase
//
//  Created by Sanket  Ray on 25/01/18.
//  Copyright © 2018 Sanket  Ray. All rights reserved.
//

import UIKit

struct Comment {
    let text : String
    let uid : String
    let user: User
    
    init(user: User, dictionary: [String: Any]) {
        self.user = user
        self.text = dictionary["text"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
    }
}
