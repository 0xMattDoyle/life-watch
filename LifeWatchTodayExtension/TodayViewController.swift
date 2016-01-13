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

    }
    
    override func viewDidAppear(animated: Bool) {
        
        calulateUsersDaysRemaining()
        
        // Show result
        let defaults = NSUserDefaults(suiteName: "group.llumicode.TodayExtensionSharingDefaults")
        defaults?.synchronize()
        //let firstName = defaults?.stringForKey("firstName")
        hoursRemainingLabel.text = "You have roughly " + (defaults?.stringForKey("usersDaysRemaining"))! + " days left, make them count!"
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
