//
//  File.swift
//  LifeWatch
//
//  Created by Matt Doyle on 7/01/2016.
//  Copyright © 2016 llumicode. All rights reserved.
//

import Foundation
import Parse
import FBSDKCoreKit
import FBSDKLoginKit
import ParseFacebookUtilsV4

// Calculates how many days a user has remaining, based on their DOB, Country and Gender.
func populateDataFromFB() {
    
    // Get input from user (currently hardcoded)
    let country = "Australia"
    
    // Save FB info to Parse
    PFUser.currentUser()?.fetchInBackgroundWithBlock({ (user, error) -> Void in
        
        if error != nil {
            
            //let user = PFUser.currentUser()
            print(user?.objectId)
            
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
                
            })
            
            // Get data from Parse
            
            // Get DOB
            let dobString = PFUser.currentUser()?.valueForKey("DOB") as? NSDate
            let unitFlags: NSCalendarUnit = [.Hour, .Day, .Month, .Year]
            let userDOB = NSCalendar.currentCalendar().components(unitFlags, fromDate: dobString!)
            
            // Query to get relevant lifeExp objectId from Parse
            let idQuery = PFQuery(className: "lifeExp")
            idQuery.whereKey("Country", equalTo: country)
            idQuery.whereKey("Gender", equalTo: user!["gender"])
            idQuery.getFirstObjectInBackgroundWithBlock { (object, error) -> Void in
                
                if error == nil {
                    
                    let objectId = object!.objectId!
                    
                    // Query to get lifeExp using objectId
                    let lifeExpQuery = PFQuery(className:"lifeExp")
                    lifeExpQuery.getObjectInBackgroundWithId(objectId) { (object, error) -> Void in
                        
                        if error == nil {
                            
                            let lifeExp = object!["y" + String(userDOB.year)] as! Double
                            print(lifeExp)
                            
                            // Calculate user's estimated lifetime
                            let totalDaysInLifetime = lifeExp * 365
                            
                            // Setup UserDefaults
                            let defaults = NSUserDefaults(suiteName: "group.llumicode.TodayExtensionSharingDefaults")
                            // Save data locally
                            defaults?.setObject(totalDaysInLifetime, forKey: "totalDaysInLifetime")
                            defaults?.setObject(dobString, forKey: "dobString")
                            defaults?.setObject(FBSDKProfile.currentProfile().firstName, forKey: "firstName")
                            defaults?.setObject(FBSDKProfile.currentProfile().lastName, forKey: "lastName")
                            defaults?.setObject(user!["gender"], forKey: "gender")
                            
                            defaults?.synchronize()
                            
                        } else {
                            
                            print(error)
                            
                        }
                        
                    }
                    
                } else {
                    
                    print(error)
                    
                }
                
            }
            
        } else {
            
            print(error)
            
        }
        
    })
    
}

func usersDaysRemaining() -> String {

    let defaults = NSUserDefaults(suiteName: "group.llumicode.TodayExtensionSharingDefaults")
    defaults?.synchronize()
    
    if
        let totalDaysInLifetime = defaults?.integerForKey("totalDaysInLifetime"),
        let dobString = defaults?.objectForKey("dobString") as! NSDate?
        
    {
        // Convert dobString to components
        let unitFlags: NSCalendarUnit = [.Hour, .Day, .Month, .Year]
        let userDOB = NSCalendar.currentCalendar().components(unitFlags, fromDate: dobString)
        print(userDOB)
        
        // Calculate age based on DOB
        let calendar : NSCalendar = NSCalendar.currentCalendar()
        let now = NSDate()
        let ageComponents = calendar.components(.Day, fromDate: dobString, toDate: now, options: [])
        let usersAgeInDays = ageComponents.day
        
        // Calculate users days remaining
        let usersDaysRemaining = totalDaysInLifetime - usersAgeInDays
        
        // Set up comma-separated number to print
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .DecimalStyle
        let usersDaysRemainingCommaSeparated = formatter.stringFromNumber(usersDaysRemaining)!
        
        // Update user defaults
        defaults?.setObject(usersDaysRemainingCommaSeparated, forKey: "usersDaysRemaining")
        defaults?.synchronize()
        
    } else {
        
        // error
        
    }
    
    return (defaults?.stringForKey("usersDaysRemaining"))!
    
}