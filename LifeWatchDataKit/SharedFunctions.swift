//
//  File.swift
//  LifeWatch
//
//  Created by Matt Doyle on 7/01/2016.
//  Copyright © 2016 llumicode. All rights reserved.
//

import Foundation

// Calculates how many days a user has remaining, based on their DOB, Country and Gender.
func usersDaysRemaining() -> String {
    
    let defaults = NSUserDefaults(suiteName: "group.llumicode.TodayExtensionSharingDefaults")
    defaults?.synchronize()
    
    if
        let totalDaysInLifetime = defaults?.integerForKey("totalDaysInLifetime"),
        let userDOB = defaults?.objectForKey("userDOB") as! NSDate?
        
    {
        
        // Calculate age based on DOB
        let calendar : NSCalendar = NSCalendar.currentCalendar()
        let now = NSDate()
        let ageComponents = calendar.components(.Day, fromDate: userDOB, toDate: now, options: [])
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