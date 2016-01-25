//
//  File.swift
//  LifeWatch
//
//  Created by Matt Doyle on 7/01/2016.
//  Copyright © 2016 llumicode. All rights reserved.
//

import Foundation
import Parse
//import FBSDKCoreKit
//import FBSDKLoginKit
//import ParseFacebookUtilsV4

let defaults = NSUserDefaults(suiteName: "group.llumicode.TodayExtensionSharingDefaults2")

// Run a query against the Parse database to calculate a user's life expectancy (days) based on users DOB, Country and gender.
func getUsersLifeExp() {
    
    // Query to get relevant lifeExp objectId from Parse
    let idQuery = PFQuery(className: "lifeExp")
    idQuery.whereKey("Country", equalTo: (defaults?.stringForKey("country"))!)
    idQuery.whereKey("Gender", equalTo: (defaults?.stringForKey("gender"))!)
    idQuery.getFirstObjectInBackgroundWithBlock { (object, error) -> Void in
        
        // Set objectId equal to the object found matching country and gender.
        let objectId = object!.objectId!
        
        // Query to get lifeExp using objectId
        let lifeExpQuery = PFQuery(className:"lifeExp")
        
        lifeExpQuery.getObjectInBackgroundWithId(objectId) { (object, error) -> Void in
            
            if error == nil {
                
                if let lifeExp = object!["y" + (defaults?.stringForKey("YOB"))!] as! Double? {
                    
                    // Calculate user's estimated lifetime
                    let totalDaysInLifetime = lifeExp * 365
                    
                    // Save calulation to defaults
                    defaults?.setObject(totalDaysInLifetime, forKey: "totalDaysInLifetime")
                    defaults?.synchronize()
                    
                    calulateUsersDaysRemaining()
                    
                }
                
            } else {
                
                print(error)
                // Run data error popup
                
                
            }
            
        }
        
    }
    
}

// Calculates how many days a user has remaining, based on their current age and their life expectancy.
func calulateUsersDaysRemaining() {
    
    defaults?.synchronize()
    
    if
        let totalDaysInLifetime = defaults?.integerForKey("totalDaysInLifetime"),
        let dobString = defaults?.stringForKey("DOB")
        
    {
        
        // Convert date string to NSDate
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        dateFormatter.locale = NSLocale(localeIdentifier: "en-AU")
        
        let calendar : NSCalendar = NSCalendar.currentCalendar()
        let now = NSDate()
        
        func calulateUsersDaysRemainingMiddle(date: NSDate) {
            
            // Calculate age based on DOB
            let ageComponents = calendar.components(.Day, fromDate: date, toDate: now, options: [])
            let usersAgeInDays = ageComponents.day
            
            // Calculate users days remaining
            let usersDaysRemaining = totalDaysInLifetime - usersAgeInDays
            
            // Set up comma-separated number to print
            let formatter = NSNumberFormatter()
            formatter.numberStyle = .DecimalStyle
            let usersDaysRemainingCommaSeparated = formatter.stringFromNumber(usersDaysRemaining)!
            
            // Update user defaults
            defaults?.setObject(usersDaysRemainingCommaSeparated, forKey: "usersDaysRemaining")
            
        }
        
        if let date = dateFormatter.dateFromString(dobString) {
            
            calulateUsersDaysRemainingMiddle(date)
            
        } else {
            
            // Duplicate code to work on simulator
            dateFormatter.locale = NSLocale(localeIdentifier: "en")
            
            if let date = dateFormatter.dateFromString(dobString) {
                
                calulateUsersDaysRemainingMiddle(date)
            }
            
        }

        defaults?.synchronize()
        
    } else {
        
        // error
        defaults?.setObject("N/A", forKey: "usersDaysRemaining")
        
    }
    
}