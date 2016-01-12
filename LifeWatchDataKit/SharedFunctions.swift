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
func saveParseDataLocally() -> Bool {
    
    print("Entering saveParseDataLocally()")
    var finished = false
    
    // Setup UserDefaults
    let defaults = NSUserDefaults(suiteName: "group.llumicode.TodayExtensionSharingDefaults")

    do {
        
        try PFUser.currentUser()?.fetch()
        
        let user = PFUser.currentUser()
        
        defaults?.setObject(user!["firstName"], forKey: "firstName")
        defaults?.setObject(user!["lastName"], forKey: "lastName")
        defaults?.setObject(user!["gender"], forKey: "gender")
        defaults?.setObject(user!["country"], forKey: "country")
        defaults?.setObject(user!["totalDaysInLifetime"], forKey: "totalDaysInLifetime")
        defaults?.setObject(user!["DOB"], forKey: "DOB")
        defaults?.setObject(user!["YOB"], forKey: "YOB")
        defaults?.setObject(user!["MOB"], forKey: "MOB")
        defaults?.setObject(user!["DayOB"], forKey: "DayOB")
        
        defaults?.synchronize()
        
        calulateUsersDaysRemaining()
        
        finished = true
        
        } catch {}
    
    return finished
    
}

// Run a query against the Parse database to calculate a user's life expectancy (days) based on users DOB, Country and gender.
func getUsersLifeExp() -> Bool {
    
    var finished = false
    
    print("Entering getUsersLifeExp()")
    
    do {
        
        try PFUser.currentUser()?.fetch()
        let user = PFUser.currentUser()
        
        // Query to get relevant lifeExp objectId from Parse
        let idQuery = PFQuery(className: "lifeExp")
        idQuery.whereKey("Country", equalTo: user!["country"])
        idQuery.whereKey("Gender", equalTo: user!["gender"])
        idQuery.getFirstObjectInBackgroundWithBlock { (object, error) -> Void in
            
            if error == nil {
                
                // Set objectId equal to the object found matrhing country and gender.
                let objectId = object!.objectId!
                
                // Query to get lifeExp using objectId
                let lifeExpQuery = PFQuery(className:"lifeExp")
                
                lifeExpQuery.getObjectInBackgroundWithId(objectId) { (object, error) -> Void in
                    
                    if error == nil {
                        
                        if let lifeExp = object!["y" + String(user!["YOB"])] as! Double? {
                            
                            // Calculate user's estimated lifetime
                            let totalDaysInLifetime = lifeExp * 365
                            
                            // Save calulation to Parse
                            print("totalDaysInLifetime: " + String(totalDaysInLifetime))
                            user!["totalDaysInLifetime"] = totalDaysInLifetime
                            
                            saveParseDataLocally()
                            
                        }
                        
                    } else {
                        
                        print(error)
                        
                    }
                    
                }
                
            } else {
                
                print("Sorry, we have no data matching that information.")
                print(error)
                
            }
            
        }
        
    } catch {}
 
    finished = true
    return finished
}

// Get user's data from their Facebook profile.
func populateDataFromFB() {
    
    print("Entering populateDataFromFB()")
    
    // Save FB info to Parse
    do {
        
        try PFUser.currentUser()?.fetch()
        let user = PFUser.currentUser()
        
        user!["firstName"] = FBSDKProfile.currentProfile().firstName
        user!["lastName"] = FBSDKProfile.currentProfile().lastName
        user!.saveInBackground()
        
        FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "gender, birthday"]).startWithCompletionHandler({ (connection, result, error) -> Void in
            
            user!["gender"] = result.valueForKey("gender")?.capitalizedString
            
            // Convert date string to NSDate
            let DOB = String(result.valueForKey("birthday")!)
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
            dateFormatter.locale = NSLocale(localeIdentifier: NSLocale.preferredLanguages()[0])
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
        
    } catch {}
    
}

// Calculates how many days a user has remaining, based on their current age and their life expectancy.
func calulateUsersDaysRemaining() -> Bool {

    var readyToSegue = false
    
    print("Entering calulateUsersDaysRemaining()")
    
    let defaults = NSUserDefaults(suiteName: "group.llumicode.TodayExtensionSharingDefaults")
    defaults?.synchronize()
    
    if
        let totalDaysInLifetime = defaults?.integerForKey("totalDaysInLifetime"),
        let dobString = defaults?.stringForKey("DOB")
        
    {
        
        // Convert date string to NSDate
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        dateFormatter.locale = NSLocale(localeIdentifier: NSLocale.preferredLanguages()[0])
        let date = dateFormatter.dateFromString(dobString)
        
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
        readyToSegue = true
        
    } else {
        
        // error
        defaults?.setObject("N/A", forKey: "usersDaysRemaining")
        
    }
    
    return readyToSegue
    
}