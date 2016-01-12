//
//  dobPickerViewController.swift
//  LifeWatch
//
//  Created by Matt Doyle on 11/01/2016.
//  Copyright © 2016 llumicode. All rights reserved.
//

import UIKit
import Parse

class dobPickerViewController: UIViewController {


    
    //IBOutlets

    
    //IBActions
    @IBAction func backDidPress(sender: AnyObject) {
    
        performSegueWithIdentifier("backToCountryPickerSegue", sender: self)
        
    }
    @IBAction func doneDidPress(sender: AnyObject) {
        
        performSegueWithIdentifier("informationCompleteSegue", sender: self)
        
    }
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
