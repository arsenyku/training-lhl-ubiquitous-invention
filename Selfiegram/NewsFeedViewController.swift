//
//  NewsFeedViewControllerTableViewController.swift
//  Selfiegram
//
//  Created by asu on 2016-01-25.
//  Copyright © 2016 asu. All rights reserved.
//
import Parse
import UIKit

class NewsFeedViewController: UITableViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {


    @IBOutlet weak var cameraButtonItem: UIBarButtonItem!
    
    @IBOutlet weak var refresh: UIRefreshControl!
    
    @IBOutlet weak var likeButton: UIButton!
    
    var posts = [Post]()

    override func viewDidLoad() {
        super.viewDidLoad()

        if TARGET_OS_SIMULATOR != 1
        {
            cameraButtonItem!.action = Selector("takeAPhoto:")
        }
        
        getPosts()
        
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

        selfieCell.displayPost(post)
        
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

    @IBAction func moreCatsPlease(sender: UIRefreshControl?) {
        
        getMoreCats()

        
    }

    
    // MARK: - UIImagePickerControllerDelegate
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage,
	        let imageData = UIImageJPEGRepresentation(image, 0.9),
    	    let imageFile = PFFile(data: imageData),
            let user = PFUser.currentUser() else
        {
            dismissViewControllerAnimated(true, completion:  {})
            return
        }
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        let comment = formatter.stringFromDate(NSDate())
        
        let newPost = Post(image:imageFile, user:user, comment:"\(comment)")
        
        newPost.saveInBackgroundWithBlock({ (success, error) -> Void in
            if success {
                print("Post successfully saved in Parse")
                
            }
        })
        
        posts.insert(newPost, atIndex:0)
        let indexPath =  NSIndexPath(forRow: 0, inSection: 0)
        self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        dismissViewControllerAnimated(true, completion:  {})
        
        
    }
    


    // MARK: - Helpers
    
    func getPosts()
    {
        if let query = Post.query() {
            query.orderByDescending("createdAt")
            query.includeKey("user")
            query.findObjectsInBackgroundWithBlock(
            { (posts, error) -> Void in
                // this block of code will run when the query is complete
                if let posts = posts as? [Post]
                {
                    self.posts = posts
                    
                    for post in posts
                    {
                        let query = post.likes.query()
                        
                        query.findObjectsInBackgroundWithBlock(
                            { (users, error) -> Void in
                                if (error != nil)
                                {
                                    print ("ERR \(error)")
                                }
                                
                                guard let users = users as? [PFUser]
                                    else
                                {
                                    return
                                }
                                
                                for user in users
                                {
                                    // If we find that the current user's objectId in our collection
                                    // of likes we set the likeButton to selected
                                    // objectId is a great way to compare if two objects are equal
                                    print ("\(user.objectId) == \(PFUser.currentUser()?.objectId)")
                                    if user.objectId == PFUser.currentUser()?.objectId
                                    {
                                        
                                        post.liked = true
                                    }
                                }
                                
                                self.tableView.reloadData()
                                
                        })
                    }
                    
                    self.tableView.reloadData()
                }
            })
        }
        
    }
    
    func getMoreCats()
    {
        
        dispatch_async(dispatch_get_main_queue(),
        {
            self.refresh.endRefreshing()
        })
        
//        let url = NSURL(string: "https://www.flickr.com/services/rest/?method=flickr.photos.search&format=json&nojsoncallback=1&api_key=e33dc5502147cf3fd3515aa44224783f&tags=cat"),
//        task = NSURLSession.sharedSession().dataTaskWithURL(url!) { (data, response, error) -> Void in
//            
//            
//            do {
//                
//                let jsonUnformatted = try NSJSONSerialization.JSONObjectWithData(data!, options: [])
//                
//                let json = jsonUnformatted as? [String : AnyObject]
//                
//                let photosDictionary = json?["photos"] as? [String : AnyObject]
//                
//                guard let photosArray = photosDictionary?["photo"] as? [[String : AnyObject]] else
//                {
//                    print("error with parsing photos in response data")
//                    return
//                }
//                
//                
//                for photo in photosArray
//                {
//                    
//                    if let farmID = photo["farm"] as? Int,
//                        let serverID = photo["server"] as? String,
//                        let photoID = photo["id"] as? String,
//                        let secret = photo["secret"] as? String,
//                        let title = photo["title"] as? String,
//                        let owner = photo["owner"] as? String
//                    {
//                        
//                        let photoURLString = "https://farm\(farmID).staticflickr.com/\(serverID)/\(photoID)_\(secret).jpg"
//                        
//                        if let _ = NSURL(string: photoURLString){
//                            let poster = PFUser()
//                            
//                            poster.username = owner
//                            
//                            let post = Post(image: PFFile, user: poster, comment: title)
////                            let post = Post(user:me, imageAddress: photoURLString, comment: title)
//                            
//                            self.posts.append(post)
//                        }
//                        
//                    }
//                    
//                }
//                
//                
//                dispatch_async(dispatch_get_main_queue(),
//                {
//                    self.tableView.reloadData()
//                    self.refresh.endRefreshing()
//                })
//                
//                
//            } catch
//            {
//                print("error with parsing response data")
//            }
//            
//        }
//        
//        task.resume()
//
        
    }
    


}
