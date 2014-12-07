//
//  ViewController.swift
//  Split
//
//  Created by Xiaotian Cao on 9/26/14.
//  Copyright (c) 2014 Xiaotian Cao. All rights reserved.
//

import UIKit

class ViewController: UIViewController, SideBarDelegate {
    var sideBar: SideBar = SideBar()
    let threadLock = NSLock();
    
    @IBOutlet var errorMessage: UILabel!
    @IBOutlet var usernameField: UITextField!
    @IBOutlet var passwordField: UITextField!
    @IBOutlet var emailField: UITextField!
    @IBOutlet var registerButton: UIButton!
    @IBOutlet var firstNameField: UITextField!
    @IBOutlet var lastNameField: UITextField!

    @IBAction func onUsernameModified(sender: AnyObject) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            self.threadLock.lock();
            var query = PFUser.query();
            query.whereKey("username", equalTo: self.usernameField.text);
            var users = query.findObjects();
            dispatch_sync(dispatch_get_main_queue(), {
                if (!users.isEmpty) {
                    self.errorMessage.text = "username taken";
                    self.errorMessage.sizeToFit();
                    self.registerButton.enabled = false;
                } else if (!self.registerButton.enabled) {
                    self.errorMessage.text = "";
                    self.errorMessage.sizeToFit();
                    self.registerButton.enabled = true;
                }
            });
            self.threadLock.unlock()
        })
    }
    
    private func error(message: String) {
        var alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func onRegister(sender: UIButton) {
        if (self.usernameField.text == nil) {
            self.errorMessage.text = "username is required";
            return;
        } else if (self.passwordField.text == nil) {
            self.errorMessage.text = "password is required";
            return;
        } else if (self.emailField.text == nil) {
            self.errorMessage.text = "email is required";
            return;
        } else if (self.firstNameField.text == nil) {
            self.errorMessage.text = "firstname is required"
            return;
        } else if (self.lastNameField.text == nil) {
            self.errorMessage.text = "lastname is required"
            return;
        }
        var newUser = PFUser();
        newUser.username = self.usernameField.text;
        newUser.password = self.passwordField.text;
        newUser.email = self.emailField.text;
        newUser.setValue(lastNameField.text, forKey: "lastName")
        newUser.setValue(firstNameField.text, forKey: "firstName")

        
        newUser.signUpInBackgroundWithBlock {
            (succeeded: Bool!, error: NSError!) -> Void in
            if error == nil {
                // Hooray! Let them use the app now.
            } else {
                self.errorMessage.text = error.userInfo!["error"]! as? String;
                self.errorMessage.sizeToFit();
            }
        }
    }
    func sideBarDidSelectButtonAtIndex(index: Int) {
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 237/255.0, green: 228/255.0, blue: 217/255.0, alpha: 1)
        sideBar = SideBar(sourceView: self.view, menuItems: ["first item", "second item"])
        }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

