//
//  ViewController.swift
//  Selfiegram
//
//  Created by asu on 2016-01-25.
//  Copyright © 2016 asu. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        nameLabel.text = "yourName"
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
        }
    
        dismissViewControllerAnimated(true, completion:  {})
    
    }

}

