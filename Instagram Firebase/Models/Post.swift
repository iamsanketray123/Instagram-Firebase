//
//  Post.swift
//  Instagram Firebase
//
//  Created by Sanket  Ray on 20/01/18.
//  Copyright © 2018 Sanket  Ray. All rights reserved.
//

import UIKit

struct Post {
    let imageUrl : String
    let user: User
    let caption : String
    
    init(user: User, dictionary : [String: Any]) {
        self.imageUrl = dictionary["imageUrl"] as? String ?? ""
        self.user = user
        self.caption = dictionary["caption"] as? String ?? ""
    }
}
