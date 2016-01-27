//
//  Post.swift
//  Selfiegram
//
//  Created by asu on 2016-01-26.
//  Copyright © 2016 asu. All rights reserved.
//

import UIKit

class Post {

    let name:String
    var imageAddress:String
    var image:UIImage!
    let comment:String

    init(name:String, comment:String)
    {
        self.name = name
        self.comment = comment
        self.imageAddress = ""
        self.image = UIImage(named: "placeholder")
    }
    
    convenience init(name:String, image: UIImage, comment:String)
    {
        self.init(name:name, comment:comment)
        self.image = image
    }
    
    convenience init(name:String, imageAddress: String, comment:String)
    {
        self.init(name:name, comment:comment)
        self.imageAddress = imageAddress
        
        let url = NSURL(string: imageAddress),
	        task = NSURLSession.sharedSession().downloadTaskWithURL(url!) { (url, response, error) -> Void in
            
            if let receivedDataUrl = url,
                let imageData = NSData(contentsOfURL: receivedDataUrl)
            {
                    
                    let image = UIImage(data: imageData)
                    self.image = image
            }
            
        }

        task.resume()
    }
    
    
}
