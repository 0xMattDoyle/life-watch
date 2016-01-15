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

// Get user's data from their Facebook profile.
func populateDataFromFB() {
    
    let defaults = NSUserDefaults(suiteName: "group.llumicode.TodayExtensionSharingDefaults")
    
    // Save FB info to Parse
    
    PFUser.currentUser()?.fetchInBackgroundWithBlock({ (user, error) -> Void in
        
        if error == nil {
            
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "gender, first_name, last_name"]).startWithCompletionHandler({ (connection, result, error) -> Void in
                
                if error == nil {
                    
                    user!["gender"] = result.valueForKey("gender")?.capitalizedString
                    defaults?.setObject(result.valueForKey("gender")?.capitalizedString, forKey: "gender")
                    defaults?.synchronize()
                    user!["firstName"] = result.valueForKey("first_name")?.capitalizedString
                    user!["lastName"] = result.valueForKey("last_name")?.capitalizedString
                    user!.saveInBackground()
                    
                }
                
            })
            
        }
        
    })
    
}

// Run a query against the Parse database to calculate a user's life expectancy (days) based on users DOB, Country and gender.
func getUsersLifeExp() {
    
    PFUser.currentUser()?.fetchInBackgroundWithBlock({ (user, error) -> Void in
        
        if error == nil {
            
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
                                
                                user?.saveInBackground()
                                saveParseDataLocally()
                                
                            }
                            
                        } else {
                            
                            print(error)
                            // Run data error popup
                            
                            
                        }
                        
                    }
                    
                } else {
                    
                    // Run data error popup
                    print(error)
                    
                }
                
            }
            
        }
        
    })
    
}

// Saves all Parse data to local defaults so that the today widget can access it.
func saveParseDataLocally() {
    
    // Setup UserDefaults
    let defaults = NSUserDefaults(suiteName: "group.llumicode.TodayExtensionSharingDefaults")

    PFUser.currentUser()?.fetchInBackgroundWithBlock({ (user, error) -> Void in
        
        if error == nil {
            
            defaults?.setObject(user!["firstName"], forKey: "firstName")
            defaults?.setObject(user!["lastName"], forKey: "lastName")
            defaults?.setObject(user!["gender"], forKey: "gender")
            defaults?.setObject(user!["country"], forKey: "country")
            defaults?.setObject(user!["totalDaysInLifetime"], forKey: "totalDaysInLifetime")
            defaults?.setObject(user!["DOB"], forKey: "DOB")
            defaults?.setObject(user!["YOB"], forKey: "YOB")
            defaults?.setObject(user!["MOB"], forKey: "MOB")
            defaults?.setObject(user!["DayOB"], forKey: "DayOB")
            defaults?.setObject(user!["countryRow"], forKey: "countryRow")
            
            defaults?.synchronize()
            
            calulateUsersDaysRemaining()
            
        }
        
    })
    
}

// Calculates how many days a user has remaining, based on their current age and their life expectancy.
func calulateUsersDaysRemaining() {
    
    let defaults = NSUserDefaults(suiteName: "group.llumicode.TodayExtensionSharingDefaults")
    defaults?.synchronize()
    
    if
        let totalDaysInLifetime = defaults?.integerForKey("totalDaysInLifetime"),
        let dobString = defaults?.stringForKey("DOB")
        
    {
        
        // Convert date string to NSDate
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        dateFormatter.locale = NSLocale(localeIdentifier: "en")
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
        
    } else {
        
        // error
        defaults?.setObject("N/A", forKey: "usersDaysRemaining")
        
    }
    
}