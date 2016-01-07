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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(FBSDKAccessToken.currentAccessToken() != nil) {
            //They are logged in so show another view
            print("Logged in")
            self.performSegueWithIdentifier("goToHomeScreen", sender: self)
        } else {
            print("Not logged in")
            self.performSegueWithIdentifier("login", sender: self)
        }
        
        // Get input from user (currently hardcoded)
        let country = "Australia"
        let gender = "Male"
        let birthYear = 1991
        let birthMonth = 7
        let birthDay = 16
        let userDOB = NSCalendar.currentCalendar().dateWithEra(1, year: birthYear, month: birthMonth, day: birthDay, hour: 0, minute: 0, second: 0, nanosecond: 0)
        
        // Calcuate lifeExpectancy based on Age, Gender and Country
        // Query to get relevant lifeExp objectId
        let idQuery = PFQuery(className: "lifeExp")
        idQuery.whereKey("Country", equalTo: country)
        idQuery.whereKey("Gender", equalTo: gender)
        idQuery.getFirstObjectInBackgroundWithBlock { (object, error) -> Void in
            
            if error == nil {
                
                let objectId = object!.objectId! 
                    
                // Query to get lifeExp using objectId
                let lifeExpQuery = PFQuery(className:"lifeExp")
                lifeExpQuery.getObjectInBackgroundWithId(objectId) { (object, error) -> Void in
                    
                    if error == nil {
                        
                        let lifeExp = object!["y" + String(birthYear)] as! Double
                        print(lifeExp)
                        
                        // Calculate user's estimated lifetime
                        let totalDaysInLifetime = lifeExp * 365
                        
                        // Setup UserDefaults
                        let defaults = NSUserDefaults(suiteName: "group.llumicode.TodayExtensionSharingDefaults")
                        // Set the string for the Today Extenstion to display
                        defaults?.setObject(totalDaysInLifetime, forKey: "totalDaysInLifetime")
                        defaults?.setObject(userDOB, forKey: "userDOB")
                        defaults?.synchronize()
                        
                    } else {
                        
                        print(error)
                        
                    }
                    
                }
                
            } else {
                
                print(error)
                
            }
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

