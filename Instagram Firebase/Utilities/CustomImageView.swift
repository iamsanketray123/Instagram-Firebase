//
//  CustomImageView.swift
//  Instagram Firebase
//
//  Created by Sanket  Ray on 20/01/18.
//  Copyright © 2018 Sanket  Ray. All rights reserved.
//

import UIKit

var imageCache = [String: UIImage]()

class CustomImageView: UIImageView {

    var lastUrlUsedToLoadImage : String? // I don't understand how it works...yet!
    
    func loadImage(urlString: String) {
        
        lastUrlUsedToLoadImage = urlString
        
        if let cachedImage = imageCache[urlString] {
            self.image = cachedImage
            return
        }
        
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            if let err = err {
                print("Failed to fetch post Image:", err)
                return
            }
            if url.absoluteString != self.lastUrlUsedToLoadImage {
                return
            }
            
            guard let imageData = data else { return }
            guard let photoImage = UIImage(data : imageData) else { return }
            imageCache[url.absoluteString] = photoImage
            DispatchQueue.main.async {
                self.image = photoImage
            }
        }.resume()
    }
}

