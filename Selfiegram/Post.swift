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
    let image:UIImage
    let comment:String 

    init(name:String, image: UIImage, comment:String)
    {
    	self.name = name
    	self.image = image
    	self.comment = comment
    }
    
}
