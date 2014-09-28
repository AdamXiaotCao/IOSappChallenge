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
    @IBOutlet var commentField: UITextField!
    
    
    var event: PFObject = PFObject(className: "Entry");
    var participants: [PFObject] = [];
    var individualFields: [UITextField] = [];
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.individualFields = [];
        var y: CGFloat = 0;
        for participant in self.participants {
            let yLoc = 230 + y * 40;
            let xLoc:CGFloat = 26;
            let xLoc2: CGFloat = 168;
            var label = UILabel(frame: CGRect(x: xLoc, y: yLoc, width: 150, height: 21));
            var firstName = participant["firstName"] as String;
            var lastName = participant["lastName"] as String;
            label.text = "\(firstName) \(lastName)";
            self.view.addSubview(label);
            var field: UITextField = UITextField(frame: CGRect(x: xLoc2, y: yLoc, width: 100, height: 21));
            field.borderStyle = UITextBorderStyle.RoundedRect;
            self.individualFields.append(field);
            self.view.addSubview(field)
            y++;
        }
    }

    @IBAction func onAmountChanged(sender: UITextField) {
        let count = self.participants.count;
        if (sender.text.isEmpty || count == 0) {
            return;
        }
        let total = sender.text.toInt();
        if (total == nil || total! <= 0) {
            error("amount must be a positive integer");
            sender.text = "";
            for field in self.individualFields {
                field.text = ""
            }
            return;
        }
        let average = total! / count;
        for field in self.individualFields {
            field.text = "\(average)";
        }
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
    

    @IBAction func onCreate(sender: UIBarButtonItem) {
        let amountString = self.amountField.text;
        if (amountString.isEmpty || amountString.toInt() == nil) {
            self.error("illegal amount");
            return;
        }
        for field in self.individualFields {
            let p = field.text;
            if (p.isEmpty || p.toInt() == nil) {
                self.error("illegal amount");
                return;
            }
        }
        let comment = self.commentField.text;
        if (comment.isEmpty) {
            self.error("comment cannot be empty");
            return;
        }
        var newEntry = PFObject(className: "Entry");
        newEntry["comment"] = comment;
        newEntry["payer"] = PFUser.currentUser();
        newEntry["event"] = self.event;
        newEntry["amount"] = amountString.toInt()!
        var dict = Dictionary<String, Int>();
        for (var i = 0; i < self.participants.count; i++) {
            dict[self.participants[i].objectId] = self.individualFields[i].text.toInt()!;
        }
        newEntry["breakdown"] = dict;
                    // TODO add friends
        newEntry.saveInBackgroundWithBlock {
            (succeeded: Bool!, error: NSError!) -> Void in
                if error == nil {
                    self.navigationController?.popViewControllerAnimated(true);
                } else {
                    self.error("Failed to create event");
            }
        }
    }

            //need to create a new entry based on the input
            
            
    

//        }
//    }
//    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//    }


}
