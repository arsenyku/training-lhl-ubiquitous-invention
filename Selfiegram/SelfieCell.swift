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
    @IBOutlet weak var beatingHeartView: UIImageView!
    
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
            
            self.saveLikedPost(post)
            
        }
        else
        {
            post.likes.removeObject(user)
            post.liked = false

            self.saveUnlikedPost(post)
        }
        
    }
    
    
    func saveLikedPost(post:Post)
    {
        guard let user = PFUser.currentUser() else { return }
        
        // We have modified the likes property on post. We must now save it to Parse
        post.saveInBackgroundWithBlock(
            { (success, error) -> Void in
                if success
                {
                    print("like from user successfully saved")
                    
                    // Creating an row in the Activity table
                    // Saving it as a "like" type
                    let activity = Activity(type: "like", post: post, user: user)
                    activity.saveInBackgroundWithBlock(
                    { (success, error) -> Void in
                        print("activity successfully saved")
                    })
                    
                }
                else
                {
                    print("error is \(error)")
                }
        })

    }
    
    
    func saveUnlikedPost(post:Post)
    {
        guard let user = PFUser.currentUser() else { return }
        
        post.saveInBackgroundWithBlock(
        {(success, error) -> Void in
            if success
            {
                print("like from user successfully removed")
                
                //PFQuery to find the like activity
                if let activityQuery = Activity.query()
                {
                    activityQuery.whereKey("post", equalTo: post)
                    activityQuery.whereKey("user", equalTo: user)
                    activityQuery.whereKey("type", equalTo: "like")
                    activityQuery.findObjectsInBackgroundWithBlock(
                    { (activities, error) -> Void in
                        
                        
                        // You should only have one like activity from a user
                        // but this is code is being safe and checking for one or multiple instances
                        // and then deleting all of them
                        if let activities = activities
                        {
                            for activity in activities
                            {
                                activity.deleteInBackgroundWithBlock(
                                { (success, error) -> Void in
                                    print("deleted activity")
                                })
                            }
                        }
                    })
                }
                
            }
            else
            {
                print("error is \(error)")
            }
        })
    }
    
    func likeButtonClicked(sender: UIButton)
    {
        toggleLikeButton(sender)
    }
    
    func tapAnimation()
    {
        let selfie = postImageView
        let floatingHeart = beatingHeartView
        let fixedHeart = likeButton
        
        
        floatingHeart.hidden = false;
        fixedHeart.hidden = true;
        floatingHeart.image = UIImage(named: fixedHeart.selected ? "hearts-off" : "hearts-on")
        
        floatingHeart.frame = CGRectMake((selfie.frame.maxX - selfie.frame.minX)/2, (selfie.frame.maxY - selfie.frame.minY)/2, 60, 60)
        
        UIView.animateKeyframesWithDuration(2.0, delay: 0, options: [.CalculationModeCubicPaced], animations:
        { () -> Void in
            for i in 0...4
            {
                let even = (i%2 == 0)
                let pulse = CGFloat(even ? 1.5 : 0.55)
                
                UIView.addKeyframeWithRelativeStartTime(0.2*Double(i), relativeDuration: 0.2)
                { () -> Void in
                    floatingHeart.transform = CGAffineTransformRotate(floatingHeart.transform, CGFloat(Double(i)*M_PI/5.0))
                    floatingHeart.transform = CGAffineTransformScale(floatingHeart.transform, pulse, pulse)

                }

            }
            
            floatingHeart.transform = CGAffineTransformIdentity
            floatingHeart.frame = fixedHeart.frame
            fixedHeart.hidden = false
            
        }, completion:
        { (success) -> Void in
            
            floatingHeart.hidden = true
            self.likeButtonClicked(fixedHeart)
            
        })
        
    }
}
