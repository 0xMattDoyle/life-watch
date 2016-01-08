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
            
            profilePicture.setNeedsImageUpdate()
            
        }
        
        // Check if user logged in
        if (FBSDKAccessToken.currentAccessToken() != nil) {
            
            //User is logged in
            populateDataFromFB()
            usersDaysRemaining()
            
        } else {
            // User is not logged in
            self.performSegueWithIdentifier("notLoggedIn", sender: self)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

