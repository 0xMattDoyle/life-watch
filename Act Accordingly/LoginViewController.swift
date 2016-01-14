//
//  LoginViewController.swift
//  LifeWatch
//
//  Created by Matt Doyle on 8/01/2016.
//  Copyright © 2016 llumicode. All rights reserved.
//

import UIKit
import Parse
import FBSDKCoreKit
import FBSDKLoginKit
import ParseFacebookUtilsV4

class LoginViewController: UIViewController {
    
    // Define the permissions the app requires from Facebook.
    let permissions = ["public_profile", "user_birthday"]
    
    @IBAction func loginButtonPressed(sender: AnyObject) {
        
        PFFacebookUtils.logInInBackgroundWithReadPermissions(permissions) {
            (user: PFUser?, error: NSError?) -> Void in
            if let user = user {
                if user.isNew {
                    print("User signed up and logged in through Facebook!")
                    populateDataFromFB()
                    self.loadFbImage()
                    self.performSegueWithIdentifier("confirmDataSegue", sender: self)
                } else {
                    print("User logged in through Facebook!")
                    self.loadFbImage()
                    self.performSegueWithIdentifier("finishedLoggingInSegue", sender: self)
                }
            } else {
                print("Uh oh. The user cancelled the Facebook login.")
            }
            
        }
        
        
        
    }
    
    func loadFbImage() {
        
        let user = PFUser.currentUser()
        let defaults = NSUserDefaults(suiteName: "group.llumicode.TodayExtensionSharingDefaults")
        
        let fbPic = FBSDKProfile.imageURLForPictureMode(FBSDKProfile.currentProfile())
        let fbPicUrl = fbPic(FBSDKProfilePictureMode.Square, size: CGSizeMake(200, 200))
        
        let request: NSURLRequest = NSURLRequest(URL: fbPicUrl)
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request){
            (data, response, error) -> Void in
            
            if (error == nil && data != nil)
            {
                func saveFbImageToParseAndDefaults()
                {
                    let file = PFFile(name: "profilePicture.png", data: data!)
                    user?["profilePicture"] = file
                    user?.saveInBackground()
                    
                    defaults!.setObject(data, forKey: "profilePicture")
                    defaults?.synchronize()
                    
                }
                
                dispatch_async(dispatch_get_main_queue(), saveFbImageToParseAndDefaults)
            }
            
        }
        
        task.resume()
        
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
