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
        postImageView.layer.cornerRadius = postImageView.layer.bounds.size.width / 2
        postImageView.layer.masksToBounds = true
    }

    func displayInfo(name name:String, imageName:String, comment:String)
    {
        postImageView!.image = UIImage(named: imageName)
		
        postNameField!.text = name
        
 		postCommentField.text = comment
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
