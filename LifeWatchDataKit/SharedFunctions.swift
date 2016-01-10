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

// Saves all Parse data to local defaults so that the today widget can access it.
func saveParseDataLocally() {
    
    print("Entering saveParseDataLocally()")
    
    // Setup UserDefaults
    let defaults = NSUserDefaults(suiteName: "group.llumicode.TodayExtensionSharingDefaults")

    do {
        
        try PFUser.currentUser()?.fetch()
            
        let user = PFUser.currentUser()
        
        defaults?.setObject(user!["firstName"], forKey: "firstName")
        defaults?.setObject(user!["lastName"], forKey: "lastName")
        defaults?.setObject(user!["gender"], forKey: "gender")
        defaults?.setObject(user!["totalDaysInLifetime"], forKey: "totalDaysInLifetime")
        defaults?.setObject(user!["DOB"], forKey: "DOB")
        defaults?.setObject(user!["YOB"], forKey: "YOB")
        defaults?.setObject(user!["MOB"], forKey: "MOB")
        defaults?.setObject(user!["DayOB"], forKey: "DayOB")
        
        defaults?.synchronize()
        
    } catch {}
    
}

// Run a query against the Parse database to calculate a user's life expectancy (days) based on users DOB, Country and gender.
func getUsersLifeExp() {
    
    print("Entering getUsersLifeExp()")
    
    PFUser.currentUser()?.fetchInBackgroundWithBlock({ (user, error) -> Void in
        
        if error == nil {

            // Query to get relevant lifeExp objectId from Parse
            let idQuery = PFQuery(className: "lifeExp")
            idQuery.whereKey("Country", equalTo: "Australia") // TODO
            idQuery.whereKey("Gender", equalTo: user!["gender"])
            idQuery.getFirstObjectInBackgroundWithBlock { (object, error) -> Void in
                
                print("1")
                
                if error == nil {
                    
                    // Set objectId equal to the object found matrhing country and gender.
                    let objectId = object!.objectId!
                    
                    // Query to get lifeExp using objectId
                    let lifeExpQuery = PFQuery(className:"lifeExp")
                    
                    lifeExpQuery.getObjectInBackgroundWithId(objectId) { (object, error) -> Void in
                        
                        if error == nil {
                            
                            let lifeExp = object!["y" + String(user!["YOB"])] as! Double
                            
                            // Calculate user's estimated lifetime
                            let totalDaysInLifetime = lifeExp * 365
                            
                            // Save calulation to Parse
                            print("totalDaysInLifetime: " + String(totalDaysInLifetime))
                            user!["totalDaysInLifetime"] = totalDaysInLifetime

                            
                        } else {
                            
                            print(error)
                            
                        }
                        
                    }
                    
                } else {
                    
                    print("Sorry, we have no data matching that information.")
                    print(error)
                    
                }
                
            }
            
        }

    })
    
}

// Get user's data from their Facebook profile.
func populateDataFromFB() {
    
    print("Entering populateDataFromFB()")
    
    // Save FB info to Parse
    PFUser.currentUser()?.fetchInBackgroundWithBlock({ (user, error) -> Void in
        
        if error == nil {
            
            user!["firstName"] = FBSDKProfile.currentProfile().firstName
            user!["lastName"] = FBSDKProfile.currentProfile().lastName
            user!.saveInBackground()
            
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "gender, birthday"]).startWithCompletionHandler({ (connection, result, error) -> Void in
                
                user!["gender"] = result.valueForKey("gender")?.capitalizedString
                
                // Convert date string to NSDate
                let DOB = String(result.valueForKey("birthday")!)
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
                dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
                let date = dateFormatter.dateFromString(DOB)
                
                // Convert NSDate to dateComponents
                let unitFlags: NSCalendarUnit = [.Hour, .Day, .Month, .Year]
                let dobComponents = NSCalendar.currentCalendar().components(unitFlags, fromDate: date!)
                user!["DOB"] = DOB
                user!["YOB"] = dobComponents.year
                user!["MOB"] = dobComponents.month
                user!["DayOB"] = dobComponents.day
                
                user!.saveInBackground()
                
            })
            
        } else {
            
            print("No user information found.")
            print(error)
            
        }
        
    })
    
}

// Calculates how many days a user has remaining, based on their current age and their life expectancy.
func calulateUsersDaysRemaining() -> String {

    print("Entering calulateUsersDaysRemaining()")
    
    let defaults = NSUserDefaults(suiteName: "group.llumicode.TodayExtensionSharingDefaults")
    defaults?.synchronize()
    
    print(defaults?.integerForKey("totalDaysInLifetime"))
    print(defaults?.stringForKey("DOB"))
    print(defaults?.integerForKey("DayOB"))
    print(defaults?.integerForKey("MOB"))
    print(defaults?.integerForKey("YOB"))
    
    if
        let totalDaysInLifetime = defaults?.integerForKey("totalDaysInLifetime"),
        let dobString = defaults?.stringForKey("DOB")
        
    {
        
        // Convert date string to NSDate
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        let date = dateFormatter.dateFromString(dobString)
        
        // Convert NSDate to dateComponents
        //let unitFlags: NSCalendarUnit = [.Hour, .Day, .Month, .Year]
        //let dobComponents = NSCalendar.currentCalendar().components(unitFlags, fromDate: date!)
        //print("dobComponents: " + String(dobComponents))
        
        // Calculate age based on DOB
        let calendar : NSCalendar = NSCalendar.currentCalendar()
        let now = NSDate()
        let ageComponents = calendar.components(.Day, fromDate: date!, toDate: now, options: [])
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
        print("usersDaysRemainingCommaSeparated: " + usersDaysRemainingCommaSeparated)
        
    } else {
        
        // error
        defaults?.setObject("N/A", forKey: "usersDaysRemaining")
        
    }
    
    return String((defaults?.stringForKey("usersDaysRemaining"))!)
    
}