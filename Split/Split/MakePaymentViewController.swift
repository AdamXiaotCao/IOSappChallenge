//
//  MakePaymentViewController.swift
//  Split
//
//  Created by Xiaotian Cao on 9/28/14.
//  Copyright (c) 2014 Xiaotian Cao. All rights reserved.
//

import UIKit

class MakePaymentViewController: UIViewController {

    @IBOutlet var venmoIdField: UITextField!
    @IBOutlet var amountField: UITextField!
    @IBOutlet var descriptionField: UILabel!
    
    var output:OutPut = OutPut(name: "", id: "", amount: 0, venmoId: "");
    var entries:[PFObject] = []
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor(red: 237/255.0, green: 228/255.0, blue: 217/255.0, alpha: 1)

        super.viewDidLoad()
        self.venmoIdField.text = "\(self.output.venmoId)";
        self.amountField.text = "\(self.output.amount)";
        self.descriptionField.text = "Paying \(self.output.name)";
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

    @IBAction func onTrasactionSuccessful(sender: UIButton) {
        var otherId = self.output.id;
        var myId = PFUser.currentUser()!.objectId;
        for entry in self.entries {
            var payerId = entry["payer"]!.objectId;
            var dict: Dictionary<String, Int> = entry["breakdown"] as Dictionary<String, Int>;
            if (payerId == otherId) {
                println(dict[myId]!);
                dict[myId]! = 0;
                println("now \(dict[myId])");
            } else if (payerId == myId) {
                println(dict[otherId]!);
                dict[otherId]! = 0;
            }
            entry.saveInBackgroundWithBlock {
                (succeeded: Bool!, error: NSError!) -> Void in
                if error == nil {
                    println("success");
                } else {
                    self.error("Failed to create event");
                }
            }
        }
        self.navigationController?.popViewControllerAnimated(true);
    }

    @IBAction func requestPaymentButton(sender: AnyObject) {
        println("here")
        if (SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook)){
            println("yo")
            let controller = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            controller.setInitialText("I am using @Split to use split bill")
            controller.completionHandler = {
                
                (result:SLComposeViewControllerResult) -> Void in
                switch result {
                case SLComposeViewControllerResult.Cancelled:
                    println("result: cancelled")
                case SLComposeViewControllerResult.Done:
                    // TODO: ADD SOME CODE FOR SUCCESS
                    println("result: done")
                }
            }
            self.presentViewController(controller, animated: true, completion: nil)
            
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
}
