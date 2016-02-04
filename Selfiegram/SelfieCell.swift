//
//  SelfieCellTableViewCell.swift
//  Selfiegram
//
//  Created by asu on 2016-01-25.
//  Copyright © 2016 asu. All rights reserved.
//

import Parse
import UIKit

class SelfieCell: UITableViewCell {

    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var postNameField: UITextField!
    @IBOutlet weak var postCommentField: UITextField!
    @IBOutlet weak var likeButton: UIButton!
    
    var post:Post?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func displayPost(post:Post)
    {
        self.post = post
        displayInfo()
    }
    
    func displayInfo()
    {
        let name = self.post!.user.username!
        let imageFile = self.post!.image
        let comment = self.post!.comment
        
        postNameField.text = name
        postCommentField.text = comment
        
        // set the likeButton defaulted to false
        likeButton.selected = self.post!.liked;

        
        postImageView.layer.masksToBounds = true
        postImageView.layer.cornerRadius = self.postImageView.layer.frame.width/2.0
        postImageView.layer.borderWidth = 0

        
        imageFile.getDataInBackgroundWithBlock { (data, error) -> Void in
            if let data = data {
                let image = UIImage(data: data)
                self.postImageView.image = image
            }
        }
        
    }
    
    
    override func setSelected(selected: Bool, animated: Bool) {
        
        super.setSelected(selected, animated: animated)

        postNameField.backgroundColor = UIColor.whiteColor();
    }

    
    @IBAction func toggleLikeButton(sender: UIButton)
    {
        // the ! symbol means NOT
        // We are therefore setting the button's selected state to
        // the opposite of what it was. This is a great way to toggle buttons
        //
        sender.selected = !sender.selected
        
        // Get rid of Optionals
        guard let post = post,
              let user = PFUser.currentUser()
        else
        {
            return
        }
        
        // like button has been selected and we should add a like from currentUser
        if sender.selected
        {
            // PFRelation has a useful method called addObject that adds the unique element
            // you are passing in as the argument. It will never add multiple copies
            // of the same element (in this case user)
            post.likes.addObject(user)
            post.liked = true
        }
        else
        {
            post.likes.removeObject(user)
            post.liked = false

        }
        
        // We have modified the likes property on post. We must now save it to Parse
        post.saveInBackgroundWithBlock(
        { (success, error) -> Void in
            if success
            {
                print("like from user successfully saved")
            }
            else
            {
                print("error is \(error)")
            }
        })

    }
}
