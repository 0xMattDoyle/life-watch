//
//  LoginViewController.swift
//  LifeWatch
//
//  Created by Matt Doyle on 8/01/2016.
//  Copyright © 2016 llumicode. All rights reserved.
//

import UIKit
import Parse
//import FBSDKCoreKit
//import FBSDKLoginKit
//import ParseFacebookUtilsV4

class LoginViewController: UIViewController {
    
    let defaults = NSUserDefaults(suiteName: "group.llumicode.TodayExtensionSharingDefaults2")
    
    @IBAction func loginButtonPressed(sender: AnyObject) {
        
        performSegueWithIdentifier("getStartedSegue", sender: self)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        defaults?.synchronize()
        
        if defaults?.boolForKey("newUser") == false {
            
            performSegueWithIdentifier("getStartedSegue", sender: self)
            
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
