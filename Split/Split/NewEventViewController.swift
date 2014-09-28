//
//  NewEventViewController.swift
//  Split
//
//  Created by Xiaotian Cao on 9/27/14.
//  Copyright (c) 2014 Xiaotian Cao. All rights reserved.
//

import UIKit

class NewEventViewController: UIViewController {

    @IBOutlet var nameField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func error(message: String) {
        var alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    @IBAction func onCreate(sender: UIButton) {
        if (self.nameField.text.isEmpty) {
            self.error("Name cannot be empty");
        } else {
            var newEvent = PFObject(className: "Event");
            newEvent["name"] = self.nameField.text;
            newEvent["participants"] = PFUser.currentUser();
            // TODO add friends
            newEvent.saveInBackgroundWithBlock {
                (succeeded: Bool!, error: NSError!) -> Void in
                if error == nil {
                    self.navigationController?.popViewControllerAnimated(true);
                } else {
                    self.error("Failed to create event");
                }
            }
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
