//
//  NewsFeedViewControllerTableViewController.swift
//  Selfiegram
//
//  Created by asu on 2016-01-25.
//  Copyright © 2016 asu. All rights reserved.
//

import UIKit

class NewsFeedViewController: UITableViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {


    @IBOutlet weak var cameraButtonItem: UIBarButtonItem!
    
    var posts = [Post]()

    override func viewDidLoad() {
        super.viewDidLoad()

        if TARGET_OS_SIMULATOR != 1
        {
            cameraButtonItem!.action = Selector("takeAPhoto:")
        }
        

//        posts.append(Post(name:"flark", image:UIImage(named: "grumpy-cat")!, comment: "start"))
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return posts.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("postCell", forIndexPath: indexPath)
        guard let selfieCell = cell as? SelfieCell else
        {
            return cell
        }
        
        let post = posts[indexPath.row]

        selfieCell.displayInfo(name: post.name, image:post.image, comment:post.comment)
        
        return selfieCell
    }


    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    
    // MARK: - Handlers
    
    @IBAction func pickAnImage(sender: AnyObject)
    {
        let pickerController = UIImagePickerController()

        pickerController.delegate = self
        
        pickerController.sourceType = .PhotoLibrary
        
        self.presentViewController(pickerController, animated: true, completion: nil);
    }
    
    @IBAction func takeAPhoto(sender: AnyObject)
    {
        let pickerController = UIImagePickerController()
        
        pickerController.delegate = self

        pickerController.sourceType = .Camera
        pickerController.cameraDevice = .Front
        pickerController.cameraCaptureMode = .Photo
        
        self.presentViewController(pickerController, animated: true, completion: nil);
        
    }

    // MARK: - UIImagePickerControllerDelegate
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else
        {
            dismissViewControllerAnimated(true, completion:  {})
            return
        }
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        let comment = formatter.stringFromDate(NSDate())
        posts.insert(Post(name:"grumpy cat", image:image, comment:"\(comment)"), atIndex:0)
        tableView.reloadData()
        dismissViewControllerAnimated(true, completion:  {})
        
        
    }

}
