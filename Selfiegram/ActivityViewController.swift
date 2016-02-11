//
//  ActivityViewControllerTableViewController.swift
//  Selfiegram
//
//  Created by asu on 2016-02-10.
//  Copyright © 2016 asu. All rights reserved.
//

import UIKit

class ActivityViewController: UITableViewController
{

    var activities: [Activity] = []
    
    @IBOutlet var tapDetector: UITapGestureRecognizer!
   
    override func viewDidLoad()
    {
        super.viewDidLoad()
        navigationItem.titleView = UIImageView(image: UIImage(named: "Selfigram-logo"))

    }
    
    override func viewDidAppear(animated: Bool)
    {
    
        getActivities()
        
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        // #warning Incomplete implementation, return the number of rows
        return activities.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
    	guard let cell = tableView.dequeueReusableCellWithIdentifier("activityCell", forIndexPath: indexPath) as? ActivityCell
 		else
        {
            return ActivityCell()
        }
        
        let activity = activities[indexPath.row]

        cell.displayActivity(activity)
        
        return cell
        
    }

    
    @IBAction func refresh(sender: UIRefreshControl)
    {
        getActivities()
    }
    
    

    
    // MARK: - Helpers
    
    func getActivities()
    {
        if let query = Activity.query() {
            query.orderByDescending("createdAt")
            query.includeKey("user")
            query.includeKey("post.user")
            query.findObjectsInBackgroundWithBlock(
            { (activities, error) -> Void in
                // this block of code will run when the query is complete
                if let activities = activities as? [Activity]
                {
                    self.activities = activities
                    self.tableView.reloadData()
                }
                
                if (self.refreshControl!.refreshing)
                {
                    dispatch_async(dispatch_get_main_queue(),
                    {
                        self.refreshControl!.endRefreshing()
                    })
                }

            })
        }
    }


}
