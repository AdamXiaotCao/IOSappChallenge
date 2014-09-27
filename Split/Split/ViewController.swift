//
//  ViewController.swift
//  Split
//
//  Created by Xiaotian Cao on 9/26/14.
//  Copyright (c) 2014 Xiaotian Cao. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var errorMessage: UILabel!
    @IBOutlet var usernameField: UITextField!
    @IBOutlet var passwordField: UITextField!
    @IBOutlet var emailField: UITextField!
    
    @IBAction func onUsernameModified(sender: AnyObject) {
        var query = PFQuery(className:"User")
    }
    
    @IBAction func onRegister(sender: UIButton) {
        var newUser = PFUser();
        newUser.username = self.usernameField.text;
        newUser.password = self.passwordField.text;
        newUser.email = self.emailField.text;
        newUser.signUpInBackgroundWithBlock {
            (succeeded: Bool!, error: NSError!) -> Void in
            if error == nil {
                // Hooray! Let them use the app now.
            } else {
                self.errorMessage.text = "Error";
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

