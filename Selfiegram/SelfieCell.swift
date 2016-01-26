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

    func displayInfo(name name:String, image:UIImage, comment:String)
    {
        postImageView!.image = image
		
        postNameField!.text = name
        
 		postCommentField.text = comment

        print(NSStringFromCGRect(postImageView.layer.frame))
        
        postImageView.layer.masksToBounds = true
        postImageView.layer.cornerRadius = postImageView.layer.frame.width/2.0
        postImageView.layer.borderWidth = 0
    }
    
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
