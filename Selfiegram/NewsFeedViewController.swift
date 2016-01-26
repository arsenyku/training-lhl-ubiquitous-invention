//
//  NewsFeedViewControllerTableViewController.swift
//  Selfiegram
//
//  Created by asu on 2016-01-25.
//  Copyright © 2016 asu. All rights reserved.
//

import UIKit

class NewsFeedViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()


    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 5
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("postCell", forIndexPath: indexPath)
        guard let selfieCell = cell as? SelfieCell else
        {
            return cell
        }

        selfieCell.displayInfo(name: "spoon", imageName: "grumpy-cat", comment: "Grumpy cat is grumpy")
        
        return selfieCell
    }


    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
