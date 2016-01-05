//
//  TodayViewController.swift
//  LifeWatchTodayExtension
//
//  Created by Matt Doyle on 22/12/2015.
//  Copyright © 2015 llumicode. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
    
    // Global variables
    
    // IBOutlets
    @IBOutlet weak var hoursRemainingLabel: UILabel!
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
        
        let defaults = NSUserDefaults(suiteName: "group.llumicode.TodayExtensionSharingDefaults")
        defaults?.synchronize()
        
        if
            let totalDaysInLifetime = defaults?.integerForKey("totalDaysInLifetime"),
            let userDOB = defaults?.objectForKey("userDOB") as! NSDate? {
                
            // Calculate age based on DOB
            let calendar : NSCalendar = NSCalendar.currentCalendar()
            let now = NSDate()
            let ageComponents = calendar.components(.Day, fromDate: userDOB, toDate: now, options: [])
            let usersAgeInDays = ageComponents.day
             
            // Calculate users days remaining
            let usersDaysRemaining = totalDaysInLifetime - usersAgeInDays
            
            // Show result
            print(usersDaysRemaining)
            hoursRemainingLabel.text = "Statistically, you have " + String(usersDaysRemaining) + " days left to do everything you will ever do. Make them count."
            
        } else {
            
            hoursRemainingLabel.text = "Please open LifeWatch first to set up."
            
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.

        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData

        completionHandler(NCUpdateResult.NewData)
    }
    
}
