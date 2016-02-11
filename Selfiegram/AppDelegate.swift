//
//  AppDelegate.swift
//  Selfiegram
//
//  Created by asu on 2016-01-25.
//  Copyright © 2016 asu. All rights reserved.
//r
import Parse

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    let APP_ID_COMMON = "5CDeHX2xNhW11QZXr9AvtBbEQY0lft4jpUuMFt9g"
    let CLIENT_KEY_COMMON = "SO1UFKR9k8RsLx1FsXzBjyI6IjsKxm2K0jcm48dG"
    
    let APP_ID = "xFXFsw0GM3cKJIO6yrEllxanzmZgnYphdqzaMoSV"
    let CLIENT_KEY = "he0o5zqe8wvBI3Z5n4SBEzdjW5iXJ8h1PwFRNTPt"

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        Activity.registerSubclass()
        Post.registerSubclass()
        
        // Initialize Parse.
        Parse.setApplicationId(APP_ID_COMMON, clientKey: CLIENT_KEY_COMMON)
        
        PFUser.enableRevocableSessionInBackground()
        
        let user = PFUser()
        let username = "arsenyk"
        let password = "arsenyk"
        user.username = username
        user.password = password
        user.signUpInBackgroundWithBlock { (success, error) -> Void in
            if success {
                print("successfully signed up a user")
            }else {
                PFUser.logInWithUsernameInBackground(username, password: password, block: { (user, error) -> Void in
                    if let user = user {
                        print("successfully logged in \(user)")
                    }
                })
				PFUser.logOutInBackgroundWithBlock({ (logoutError) -> Void in
                    PFUser.logInWithUsernameInBackground(username, password: password, block: { (user, error) -> Void in
                        if let user = user {
                            print("successfully logged in \(user)")
                        }
                    })
                })
                
            }
        }
        return true
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
        print("Logging out")
        PFUser.logOut()
    }


}

