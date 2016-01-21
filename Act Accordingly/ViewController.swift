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
//import FBSDKCoreKit
//import FBSDKLoginKit
//import ParseFacebookUtilsV4

class ViewController: UIViewController {
    
    deinit {
        NSUserDefaults.standardUserDefaults().removeObserver(self, forKeyPath: "usersDaysRemainingCommaSeparated", context: nil)
    }
    
    // IBOutlets
    @IBOutlet weak var dashMessage: UILabel!
    @IBOutlet weak var lifeExpNumber: UILabel!
    @IBOutlet weak var daysLeftNumber: UILabel!
    
    // IBActions
    
    @IBAction func editDidPress(sender: AnyObject) {
        
        if Reachability.isConnectedToNetwork() == true {
            
            performSegueWithIdentifier("editSegue", sender: self)
            
        } else {
            let alert = UIAlertView(title: "Hmm, we can't find a network connection", message: "Profile currently unavailable.", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Reachability.isConnectedToNetwork() == true {
            // Internet connection okay
        } else {
            let alert = UIAlertView(title: "Hmm, we can't find a network connection", message: "Make sure your device is connected to the internet.", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }
        
        // Load user defaults
        let defaults = NSUserDefaults(suiteName: "group.llumicode.TodayExtensionSharingDefaults2")
        defaults?.synchronize()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "defaultsChanged:", name: NSUserDefaultsDidChangeNotification, object: nil)
        
    }
    
    func defaultsChanged(notification:NSNotification){
        
        let defaults = NSUserDefaults(suiteName: "group.llumicode.TodayExtensionSharingDefaults2")
        defaults?.synchronize()
        
        if defaults?.boolForKey("newUser") == false {
            
            //User is not new, so do things with their data.
            updateDashText()
            
        } else {
            // User has no data
        }
        
    }
    
    func updateDashText () {
        
        let defaults = NSUserDefaults(suiteName: "group.llumicode.TodayExtensionSharingDefaults2")
        defaults?.synchronize()
        
        if defaults?.stringForKey("usersDaysRemaining") != nil && defaults?.stringForKey("totalDaysInLifetime") != nil {
            
            let totalDaysInLifetime = defaults?.integerForKey("totalDaysInLifetime")
            let lifeExp = totalDaysInLifetime! / 365
            let usersDaysRemaining = defaults?.stringForKey("usersDaysRemaining")
            self.lifeExpNumber.text = String(lifeExp)
            self.daysLeftNumber.text = usersDaysRemaining
            
            let textString = "You're expected to live to " + String(lifeExp) + ", that's " + String(usersDaysRemaining!) + " days to do everything you'll ever do. Make them count!"
            
            self.dashMessage.text = textString
            
        }
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        let defaults = NSUserDefaults(suiteName: "group.llumicode.TodayExtensionSharingDefaults2")
        defaults?.synchronize()
            
        //User is logged in, so do things with all of the data.
        if defaults?.boolForKey("isNew") == true {
                
            defaults?.setObject(false, forKey: "isNew")
            performSegueWithIdentifier("editSegue", sender: self)
                
        } else {
            
        updateDashText()
            
        } else {
            // User is not logged in
            self.performSegueWithIdentifier("newUser", sender: self)
        }
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

