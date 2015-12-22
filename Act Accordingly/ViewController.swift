//
//  ViewController.swift
//  Act Accordingly
//
//  Created by Matt Doyle on 22/12/2015.
//  Copyright © 2015 llumicode. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var calculatedLifeDuration = 0
    var currentHoursRemaining = "50,403"

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let defaults = NSUserDefaults(suiteName: "group.llumicode.TodayExtensionSharingDefaults")
        defaults?.setObject("50,403", forKey: "currentHoursRemaining")
        defaults?.synchronize()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

