//
//  ViewController.swift
//  Act Accordingly
//
//  Created by Matt Doyle on 22/12/2015.
//  Copyright © 2015 llumicode. All rights reserved.
//  Matt, go to http://www.colorhunt.co/c/3986 for the pallet.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Calcuate totalEstimatedLifetime based on Age, Gender and Country
        

        
        // Get input from user (currently hardcoded)
        // let country = "Australia"
        // let gender = "Male"
        let birthYear = 1991
        let birthMonth = 7
        let birthDay = 16
        
        // Calculate age based on DOB
        
        let userDOB = NSCalendar.currentCalendar().dateWithEra(1, year: birthYear, month: birthMonth, day: birthDay, hour: 0, minute: 0, second: 0, nanosecond: 0)
        //let ageComponents = calendar.components(.Day, fromDate: userDOB!, toDate: now, options: [])
        //let age = ageComponents.day
        
        // Calculate user's estimated lifetime
        let totalDaysInLifetime = 74.3 * 365
        
        // Setup UserDefaults
        let defaults = NSUserDefaults(suiteName: "group.llumicode.TodayExtensionSharingDefaults")
        // Set the string for the Today Extenstion to display
        defaults?.setObject(totalDaysInLifetime, forKey: "totalDaysInLifetime")
        defaults?.setObject(userDOB, forKey: "userDOB")
        defaults?.synchronize()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

