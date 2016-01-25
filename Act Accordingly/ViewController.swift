//
//  ViewController.swift
//  Act Accordingly
//
//  Created by Matt Doyle on 22/12/2015.
//  Copyright © 2015 llumicode. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController {
    
    let defaults = NSUserDefaults(suiteName: "group.llumicode.TodayExtensionSharingDefaults2")
    
    deinit {
        NSUserDefaults.standardUserDefaults().removeObserver(self, forKeyPath: "usersDaysRemainingCommaSeparated", context: nil)
    }
    
    // IBOutlets
    @IBOutlet weak var dashMessage: UILabel!
    @IBOutlet weak var ripMessage: UILabel!
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
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "defaultsChanged:", name: NSUserDefaultsDidChangeNotification, object: nil)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        defaults?.synchronize()
        
        print(defaults?.objectForKey("newUser"))
        
        if defaults?.objectForKey("newUser") == nil {
            
            performSegueWithIdentifier("getStartedSegue", sender: self)
            
        } else if (defaults?.objectForKey("newUser"))! as! String == "getStarted" {
            
            performSegueWithIdentifier("editSegue", sender: self)
            
        } else if (defaults?.objectForKey("newUser"))! as! String == "userSetUp" {
            
            if Reachability.isConnectedToNetwork() == true {
                
                getUsersLifeExp()
                
            }
            
        }
        
    }
    
    func defaultsChanged(notification:NSNotification){
        
        updateDashText()
        
    }
    
    func updateDashText () {
        
        defaults?.synchronize()
        
        // Dash message
        if defaults?.stringForKey("usersDaysRemaining") != nil && defaults?.stringForKey("totalDaysInLifetime") != nil {
            
            let totalDaysInLifetime = defaults?.integerForKey("totalDaysInLifetime")
            let lifeExp = totalDaysInLifetime! / 365
            let usersDaysRemaining = defaults?.stringForKey("usersDaysRemaining")
            self.lifeExpNumber.text = String(lifeExp)
            self.daysLeftNumber.text = usersDaysRemaining
            
            let textString = "You're expected to live to " + String(lifeExp) + ", that gives you " + String(usersDaysRemaining!) + " more days to do everything you'll ever do. Make them count!"
            
            self.dashMessage.text = textString
            
            // RIP message
            let deathYear = (defaults?.integerForKey("YOB"))! + ((defaults?.integerForKey("totalDaysInLifetime"))! / 365)
            ripMessage.text = (defaults?.stringForKey("YOB"))! + " - " + String(deathYear)
            
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

