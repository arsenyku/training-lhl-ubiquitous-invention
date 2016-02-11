//
//  ViewController.swift
//  Selfiegram
//
//  Created by asu on 2016-01-25.
//  Copyright © 2016 asu. All rights reserved.
//

import Parse
import UIKit

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        nameLabel.text = "yourName"
        navigationItem.titleView = UIImageView(image: UIImage(named: "Selfigram-logo"))

    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let user = PFUser.currentUser(){
            nameLabel.text = user.username
            
            if let imageFile = user["avatarImage"] as? PFFile {
                
                imageFile.getDataInBackgroundWithBlock({ (data, error) -> Void in
                    if let imageData = data {
                        self.profileImageView.image = UIImage(data: imageData)
                    }
                })
            }
        }
    }

    @IBAction func takeAPhoto(sender: AnyObject)
    {
        let pickerController = UIImagePickerController()
        
        pickerController.delegate = self
        
        if TARGET_OS_SIMULATOR == 1
        {
            return
        }
        else
        {
            pickerController.sourceType = .Camera
            pickerController.cameraDevice = .Front
            pickerController.cameraCaptureMode = .Photo
        }
        
        self.presentViewController(pickerController, animated: true, completion: nil);

    }
    
    
    @IBAction func pickAnImage(sender: AnyObject)
    {
		let pickerController = UIImagePickerController()
    
    
        pickerController.delegate = self

        pickerController.sourceType = .PhotoLibrary
        
        self.presentViewController(pickerController, animated: true, completion: nil);
    }

    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
        	profileImageView.image = image
            
            if let imageData = UIImageJPEGRepresentation(image, 0.9),
                let imageFile = PFFile(data: imageData),
                let user = PFUser.currentUser(){
                    
                    // avatarImage is a new column in our User table
                    user["avatarImage"] = imageFile
                    user.saveInBackgroundWithBlock({ (success, error) -> Void in
                        if success {
                            print("avatarImage successfully saved")
                        }
                    })
                    
                    
            }
        }
    
        dismissViewControllerAnimated(true, completion:  {})
    
    }

}

