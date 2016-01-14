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
    
    deinit {
        NSUserDefaults.standardUserDefaults().removeObserver(self, forKeyPath: "usersDaysRemainingCommaSeparated", context: nil)
    }
    
    // IBOutlets
    @IBOutlet weak var dashMessage: UILabel!
    @IBOutlet weak var nameHeader: UILabel!
    @IBOutlet weak var lifeExpNumber: UILabel!
    @IBOutlet weak var daysLeftNumber: UILabel!
    @IBOutlet weak var profilePictureView: UIImageView!
    
    // IBActions
    @IBAction func logOutDidPress(sender: AnyObject) {
        
        PFUser.logOut()
        self.performSegueWithIdentifier("notLoggedIn", sender: self)
        
    }
    
    @IBAction func editDidPress(sender: AnyObject) {
        
        performSegueWithIdentifier("editSegue", sender: self)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load user defaults
        let defaults = NSUserDefaults(suiteName: "group.llumicode.TodayExtensionSharingDefaults")
        defaults?.synchronize()
        
        // Get image from user defaults
        let image = UIImage(data:defaults?.objectForKey("profilePicture") as! NSData)
        self.profilePictureView.image = image
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "defaultsChanged:", name: NSUserDefaultsDidChangeNotification, object: nil)
        
        // Watch for changes in user profile
        FBSDKProfile.enableUpdatesOnAccessTokenChange(true)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onProfileUpdated:", name: FBSDKProfileDidChangeNotification, object: nil)
        
        // Check if user logged in
        if (FBSDKAccessToken.currentAccessToken() != nil) {
            
            //User is logged in, so do things with all of the data.
            updateDashText()
            
        } else {
            // User is not logged in
            self.performSegueWithIdentifier("notLoggedIn", sender: self)
        }
        
    }
    
    func defaultsChanged(notification:NSNotification){
        
        updateDashText()
        
    }
    
    // Function runs when users profile changes - Currently disabled
    func onProfileUpdated(notification: NSNotification) {
        

    }
    
    func updateDashText () {
        
        let defaults = NSUserDefaults(suiteName: "group.llumicode.TodayExtensionSharingDefaults")
        defaults?.synchronize()
        
        let firstName = defaults?.stringForKey("firstName")
        let lastName = defaults?.stringForKey("lastName")
        let totalDaysInLifetime = defaults?.integerForKey("totalDaysInLifetime")
        let lifeExp = totalDaysInLifetime! / 365
        let usersDaysRemaining = defaults?.stringForKey("usersDaysRemaining")
        nameHeader.text = firstName! + " " + lastName!
        lifeExpNumber.text = String(lifeExp)
        daysLeftNumber.text = usersDaysRemaining
        
        let textString = String(firstName!) + ", you're expected to make it to " + String(lifeExp) + ". You have " + String(usersDaysRemaining!) + " roughly days left to do everything that you will ever do. Make them count!"
        
        dashMessage.text = textString
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

