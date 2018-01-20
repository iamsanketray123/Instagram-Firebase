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
    
    init(dictionary : [String: Any]) {
        self.imageUrl = dictionary["imageUrl"] as? String ?? ""
    }
}
