//
//  AppDelegate.swift
//  Selfiegram
//
//  Created by asu on 2016-01-25.
//  Copyright © 2016 asu. All rights reserved.
//
import Parse

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        Post.registerSubclass()
        
        // Initialize Parse.
        Parse.setApplicationId("xFXFsw0GM3cKJIO6yrEllxanzmZgnYphdqzaMoSV",
            clientKey: "he0o5zqe8wvBI3Z5n4SBEzdjW5iXJ8h1PwFRNTPt")
        
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
            }
        }
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

