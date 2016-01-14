//
//  countryPickerViewController.swift
//  LifeWatch
//
//  Created by Matt Doyle on 11/01/2016.
//  Copyright © 2016 llumicode. All rights reserved.
//

import UIKit
import Parse

class countryPickerViewController: UIViewController {

    // Global variables
    let user = PFUser.currentUser()
    
    // IBOutlets
    @IBOutlet weak var countryPickerView: UIPickerView!
    @IBOutlet weak var gender: UISegmentedControl!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    // IBActions
    @IBAction func logOutDidPress(sender: AnyObject) {
        
        PFUser.logOut()
        self.performSegueWithIdentifier("logout", sender: self)
        
    }
    
    @IBAction func genderDidSelect(sender: AnyObject) {
        
        switch gender.selectedSegmentIndex
            
        {
            
        case 0: user!["gender"] = "Male";

        case 1: user!["gender"] = "Female";
            
        default: break;
            
        }
        
        user?.saveInBackground()
        
    }
    
    @IBAction func doneDidPress(sender: AnyObject) {
        
        performSegueWithIdentifier("doneSegue", sender: self)

        getUsersLifeExp()
        
    }
    
    let pickerValues = [
        "Aruba",
        "Afghanistan",
        "Albania",
        "Algeria",
        "American Samoa",
        "Andorra",
        "Angola",
        "Antigua and Barbuda",
        "Arab World",
        "Argentina",
        "Armenia",
        "Australia",
        "Austria",
        "Azerbaijan",
        "Bahamas, The",
        "Bahrain",
        "Bangladesh",
        "Barbados",
        "Belarus",
        "Belgium",
        "Belize",
        "Benin",
        "Bermuda",
        "Bhutan",
        "Bolivia",
        "Bosnia and Herzegovina",
        "Botswana",
        "Brazil",
        "Brunei Darussalam",
        "Bulgaria",
        "Burkina Faso",
        "Burundi",
        "Cabo Verde",
        "Cambodia",
        "Cameroon",
        "Canada",
        "Cayman Islands",
        "Central African Republic",
        "Chad",
        "Channel Islands",
        "Chile",
        "China",
        "Colombia",
        "Comoros",
        "Congo, Dem. Rep.",
        "Congo, Rep.",
        "Costa Rica",
        "Cote d'Ivoire",
        "Croatia",
        "Cuba",
        "Curacao",
        "Cyprus",
        "Czech Republic",
        "Denmark",
        "Djibouti",
        "Dominica",
        "Dominican Republic",
        "Ecuador",
        "Egypt, Arab Rep.",
        "El Salvador",
        "Equatorial Guinea",
        "Eritrea",
        "Estonia",
        "Ethiopia",
        "European Union",
        "Faeroe Islands",
        "Fiji",
        "Finland",
        "France",
        "French Polynesia",
        "Gabon",
        "Gambia, The",
        "Georgia",
        "Germany",
        "Ghana",
        "Greece",
        "Greenland",
        "Grenada",
        "Guam",
        "Guatemala",
        "Guinea-Bissau",
        "Guinea",
        "Guyana",
        "Haiti",
        "Honduras",
        "Hong Kong SAR, China",
        "Hungary",
        "Iceland",
        "India",
        "Indonesia",
        "Iran, Islamic Rep.",
        "Iraq",
        "Ireland",
        "Isle of Man",
        "Israel",
        "Italy",
        "Jamaica",
        "Japan",
        "Jordan",
        "Kazakhstan",
        "Kenya",
        "Kiribati",
        "Korea, Dem. Rep.",
        "Korea, Rep.",
        "Kosovo",
        "Kuwait",
        "Kyrgyz Republic",
        "Lao PDR",
        "Latvia",
        "Lebanon",
        "Lesotho",
        "Liberia",
        "Libya",
        "Liechtenstein",
        "Lithuania",
        "Luxembourg",
        "Macao SAR, China",
        "Macedonia, FYR",
        "Madagascar",
        "Malawi",
        "Malaysia",
        "Maldives",
        "Mali",
        "Malta",
        "Marshall Islands",
        "Mauritania",
        "Mauritius",
        "Mexico",
        "Middle income",
        "Moldova",
        "Monaco",
        "Mongolia",
        "Montenegro",
        "Morocco",
        "Mozambique",
        "Myanmar",
        "Namibia",
        "Nepal",
        "Netherlands",
        "New Caledonia",
        "New Zealand",
        "Nicaragua",
        "Niger",
        "Nigeria",
        "North America",
        "Northern Mariana Islands",
        "Norway",
        "Oman",
        "Pakistan",
        "Palau",
        "Panama",
        "Papua New Guinea",
        "Paraguay",
        "Peru",
        "Philippines",
        "Poland",
        "Portugal",
        "Puerto Rico",
        "Qatar",
        "Romania",
        "Russian Federation",
        "Rwanda",
        "Samoa",
        "San Marino",
        "Sao Tome and Principe",
        "Saudi Arabia",
        "Senegal",
        "Serbia",
        "Seychelles",
        "Sierra Leone",
        "Singapore",
        "Sint Maarten (Dutch part)",
        "Slovak Republic",
        "Slovenia",
        "Solomon Islands",
        "Somalia",
        "South Africa",
        "South Asia",
        "South Sudan",
        "Spain",
        "Sri Lanka",
        "St. Kitts and Nevis",
        "St. Lucia",
        "St. Martin (French part)",
        "St. Vincent and the Grenadines",
        "Sudan",
        "Suriname",
        "Swaziland",
        "Sweden",
        "Switzerland",
        "Syrian Arab Republic",
        "Tajikistan",
        "Tanzania",
        "Thailand",
        "Timor-Leste",
        "Togo",
        "Tonga",
        "Trinidad and Tobago",
        "Tunisia",
        "Turkey",
        "Turkmenistan",
        "Tuvalu",
        "Uganda",
        "Ukraine",
        "United Arab Emirates",
        "United Kingdom",
        "United States",
        "Uruguay",
        "Uzbekistan",
        "Vanuatu",
        "Venezuela, RB",
        "Vietnam",
        "Virgin Islands (U.S.)",
        "West Bank and Gaza",
        "Yemen, Rep.",
        "Zambia",
        "Zimbabwe"]
    
    override func viewWillAppear(animated: Bool) {
        
        // Set up current Parse user
        let user = PFUser.currentUser()
        user?.fetchInBackgroundWithBlock({ (user, error) -> Void in
            
            if user?["country"] == nil {
                
                user?["country"] = "Aruba"
                user!["countryRow"] = 0
                user?.saveInBackground()
                
            }
            
            if user?["DOB"] == nil {
                
                user?["DOB"] = "01/01/1990"
                user!["YOB"] = 1990
                user!["MOB"] = 01
                user!["DayOB"] = 1990
                
                user?.saveInBackground()
                
            }
            
            if user?["gender"] == nil {
                
                user?["gender"] = "Male"
                user?.saveInBackground()
                
            }
            
            // added this
            // Set up date formatter
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
            dateFormatter.locale = NSLocale(localeIdentifier: NSLocale.preferredLanguages()[0])
            
            // Set up date picker to saved values
            if let initialDateString: String = user!["DOB"] as? String {
                
                let initialDate = dateFormatter.dateFromString(initialDateString)!
                self.datePicker.setDate(initialDate, animated: false)
                
            }
            
            // Keep date selection within range of data
            let datePickerMaxDate = dateFormatter.dateFromString("31/12/2013")!
            let datePickerMinDate = dateFormatter.dateFromString("30/12/1960")!
            self.datePicker.maximumDate = datePickerMaxDate
            self.datePicker.minimumDate = datePickerMinDate
            
            
            // Save date picker value to Parse when date changed
            self.datePicker.addTarget(self, action: Selector("datePickerChanged:"), forControlEvents: UIControlEvents.ValueChanged)
            
            // Set up gender selction to FB value
            if String(user!["gender"]) == "Male" {
                
                self.gender.selectedSegmentIndex = 0
                
            } else {
                
                self.gender.selectedSegmentIndex = 1
                
            }
            
            // Set up country selection to current value
            if let countryRow = user!["countryRow"] {
                
                self.countryPickerView.selectRow(Int(countryRow as! NSNumber), inComponent: 0, animated: false)
                
            }
            
        })
        
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        

        
    }
    
    // Set up country picker
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerValues.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return pickerValues[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(pickerValues[row])
        
        let user = PFUser.currentUser()
        user!["country"] = pickerValues[row]
        user!["countryRow"] = row
        user?.saveInBackground()
    }
    
    // Runs when the date picker is changed
    func datePickerChanged(datePicker:UIDatePicker) {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        dateFormatter.locale = NSLocale(localeIdentifier: NSLocale.preferredLanguages()[0])
        
        let strDate = dateFormatter.stringFromDate(datePicker.date)
        user!["DOB"]  = strDate
        
        // Convert NSDate to dateComponents
        let unitFlags: NSCalendarUnit = [.Hour, .Day, .Month, .Year]
        let dobComponents = NSCalendar.currentCalendar().components(unitFlags, fromDate: datePicker.date)
        user!["YOB"] = dobComponents.year
        user!["MOB"] = dobComponents.month
        user!["DayOB"] = dobComponents.day
        
        user?.saveInBackground()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
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
