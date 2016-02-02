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
    
    var posts = [Post]()

    override func viewDidLoad() {
        super.viewDidLoad()

        if TARGET_OS_SIMULATOR != 1
        {
            cameraButtonItem!.action = Selector("takeAPhoto:")
        }
        
        getMoreCats()
        
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
        	  let user = PFUser.currentUser(),
              let username = user.username else
        {
            dismissViewControllerAnimated(true, completion:  {})
            return
        }
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        let comment = formatter.stringFromDate(NSDate())
        
        posts.insert(Post(name:username, image:image, comment:"\(comment)"), atIndex:0)
        tableView.reloadData()
        dismissViewControllerAnimated(true, completion:  {})
        
        
    }
    

    // MARK: - Helpers
    
    func getMoreCats()
    {
        let url = NSURL(string: "https://www.flickr.com/services/rest/?method=flickr.photos.search&format=json&nojsoncallback=1&api_key=e33dc5502147cf3fd3515aa44224783f&tags=cat"),
        task = NSURLSession.sharedSession().dataTaskWithURL(url!) { (data, response, error) -> Void in
            
            
            do {
                
                let jsonUnformatted = try NSJSONSerialization.JSONObjectWithData(data!, options: [])
                
                let json = jsonUnformatted as? [String : AnyObject]
                
                let photosDictionary = json?["photos"] as? [String : AnyObject]
                
                guard let photosArray = photosDictionary?["photo"] as? [[String : AnyObject]] else
                {
                    print("error with parsing photos in response data")
                    return
                }
                
                
                for photo in photosArray
                {
                    
                    if let farmID = photo["farm"] as? Int,
                        let serverID = photo["server"] as? String,
                        let photoID = photo["id"] as? String,
                        let secret = photo["secret"] as? String,
                        let title = photo["title"] as? String,
                        let owner = photo["owner"] as? String
                    {
                        
                        let photoURLString = "https://farm\(farmID).staticflickr.com/\(serverID)/\(photoID)_\(secret).jpg"
                        
                        if let _ = NSURL(string: photoURLString){
                            let me = User()
                            
                            me.name = owner
                            me.profileImage = UIImage(named: "grumpy-cat")!
                            
                            let post = Post(name: me.name, imageAddress: photoURLString, comment: title)
                            
                            self.posts.append(post)
                        }
                        
                    }
                    
                }
                
                
                dispatch_async(dispatch_get_main_queue(),
                {
                    self.tableView.reloadData()
                    self.refresh.endRefreshing()
                })
                
                
            } catch
            {
                print("error with parsing response data")
            }
            
        }
        
        task.resume()

        
    }
    


}
