//
//  ActivityCell.swift
//  Selfiegram
//
//  Created by asu on 2016-02-10.
//  Copyright © 2016 asu. All rights reserved.
//

import UIKit

class ActivityCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

   
    func displayActivity(activity: Activity)
    {
        
        guard let poster = activity.post.user.username,
              let liker = activity.user.username
        else
        {
            return
        }
        
        self.textLabel?.text = "💖 \(liker) liked \(poster)'s photo"
        
    }
    

}
