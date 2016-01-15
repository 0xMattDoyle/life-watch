//
//  LoginViewController.swift
//  LifeWatch
//
//  Created by Matt Doyle on 8/01/2016.
//  Copyright © 2016 llumicode. All rights reserved.
//

import UIKit
import Parse
import FBSDKCoreKit
import FBSDKLoginKit
import ParseFacebookUtilsV4

class LoginViewController: UIViewController {
    
    // Define the permissions the app requires from Facebook.
    let permissions = ["public_profile"]
    
    @IBAction func loginButtonPressed(sender: AnyObject) {
        
        let defaults = NSUserDefaults(suiteName: "group.llumicode.TodayExtensionSharingDefaults2")
        defaults?.synchronize()
        
        PFFacebookUtils.logInInBackgroundWithReadPermissions(permissions) {
            (user: PFUser?, error: NSError?) -> Void in
            if let user = user {
                if user.isNew {
                    //print("User signed up and logged in through Facebook!")
                    populateDataFromFB()
                    defaults?.setBool(true, forKey: "isNew")
                    defaults?.synchronize()
                    
                    self.performSegueWithIdentifier("unwindToDash", sender: self)
                    
                } else {
                    //print("User logged in through Facebook!")
                    self.performSegueWithIdentifier("unwindToDash", sender: self)
                    populateDataFromFB()
                    getUsersLifeExp()
                    
                    defaults?.setBool(false, forKey: "isNew")
                    defaults?.synchronize()
                }
            } else {
                //print("Uh oh. The user cancelled the Facebook login.")
            }
            
        }
        
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Check if user logged in
        if (FBSDKAccessToken.currentAccessToken() != nil) {
            
            //User is logged in, so do things with all of the data.
            
            
        } else {
            // User is not logged in
            
        }


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
