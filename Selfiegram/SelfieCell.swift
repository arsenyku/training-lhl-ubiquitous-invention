//
//  SelfieCellTableViewCell.swift
//  Selfiegram
//
//  Created by asu on 2016-01-25.
//  Copyright © 2016 asu. All rights reserved.
//

import UIKit

class SelfieCell: UITableViewCell {

    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var postNameField: UITextField!
    @IBOutlet weak var postCommentField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func displayPost(post:Post)
    {
        displayInfo(name: post.name, imageAddress: post.imageUrl, comment: post.comment)
    }
    
    func displayInfo(name name:String, imageAddress:String, comment:String)
    {
        postNameField.text = name
        postCommentField.text = comment

        
        postImageView.layer.masksToBounds = true
        postImageView.layer.cornerRadius = self.postImageView.layer.frame.width/2.0
        postImageView.layer.borderWidth = 0
        
        guard let imageUrl = NSURL(string: imageAddress) else
        {
            return
        }
        let task = NSURLSession.sharedSession().downloadTaskWithURL(imageUrl) { (url, response, error) -> Void in
            
            if let receivedDataUrl = url,
                let imageData = NSData(contentsOfURL: receivedDataUrl){

                    let image = UIImage(data: imageData)

                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        
                        self.postImageView.image = image
                    
                    })
            }
            
        }
        
        task.resume()
     }
    
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
