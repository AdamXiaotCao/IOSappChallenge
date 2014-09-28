//
//  AddEntryViewController.swift
//  Split
//
//  Created by Xiaotian Cao on 9/28/14.
//  Copyright (c) 2014 Xiaotian Cao. All rights reserved.
//

import UIKit

class AddEntryViewController: UIViewController {

    @IBOutlet var amountField: UITextField!
    
    
    var event: PFObject = PFObject(className: "Entry");
    var participants: [PFObject] = [];
    
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
    


            //need to create a new entry based on the input
            
            
            
//            var newEntry = PFObject(className: "Entry");
//            newEntry["name"] = self.nameField.text;
//            var participants = newEvent.relationForKey("participants")
//            participants.addObject(PFUser.currentUser());
//            // TODO add friends
//            newEvent.saveInBackgroundWithBlock {
//                (succeeded: Bool!, error: NSError!) -> Void in
//                if error == nil {
//                    self.navigationController?.popViewControllerAnimated(true);
//                } else {
//                    self.error("Failed to create event");
//                }
//            }
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//    }


}
