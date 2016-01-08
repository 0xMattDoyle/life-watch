//
//  ViewController.swift
//  Act Accordingly
//
//  Created by Matt Doyle on 22/12/2015.
//  Copyright © 2015 llumicode. All rights reserved.
//  Matt, go to http://www.colorhunt.co/c/3986 for the pallet.
//

import UIKit
import Parse
import FBSDKCoreKit
import FBSDKLoginKit
import ParseFacebookUtilsV4

class ViewController: UIViewController {
    
    // IBOutlets
    @IBOutlet weak var profilePicture: FBSDKProfilePictureView!
    
    // IBActions
    @IBAction func logOutDidPress(sender: AnyObject) {
        
        PFUser.logOut()
        self.performSegueWithIdentifier("notLoggedIn", sender: self)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Watch for changes in user profile
        FBSDKProfile.enableUpdatesOnAccessTokenChange(true)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onProfileUpdated:", name: FBSDKProfileDidChangeNotification, object: nil)
    
        // Function runs when users profile changes
        func onProfileUpdated(notification: NSNotification) {
            
            // Change found
            profilePicture.setNeedsImageUpdate()
            
        }
        
        // Check if user logged in
        if(FBSDKAccessToken.currentAccessToken() != nil) {
            //They are logged in
            
            // Save FB info to Parse
            let user = PFUser.currentUser()
            user!["firstName"] = FBSDKProfile.currentProfile().firstName
            user!["lastName"] = FBSDKProfile.currentProfile().lastName
            user!.saveInBackground()
            
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "gender, birthday"]).startWithCompletionHandler({ (connection, result, error) -> Void in
                
                user!["gender"] = result.valueForKey("gender")
                let DOB = result.valueForKey("birthday")
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
                let date = dateFormatter.dateFromString(String(DOB!))
                user!["DOB"] = date
                user!.saveInBackground()
                
                usersDaysRemaining()
                
            })

            
        } else {
            print("Not logged in")
            self.performSegueWithIdentifier("notLoggedIn", sender: self)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

