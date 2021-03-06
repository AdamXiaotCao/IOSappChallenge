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
    @IBOutlet var paymentButton: UIButton!
    
    var output:OutPut = OutPut(name: "", id: "", amount: 0, venmoId: "");
    var entries:[PFObject] = []
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor(red: 237/255.0, green: 228/255.0, blue: 217/255.0, alpha: 1)
        amountField.keyboardType = UIKeyboardType.NumberPad
        super.viewDidLoad()
        self.venmoIdField.text = "\(self.output.venmoId)";
        self.amountField.text = "\(self.output.amount)";
        self.descriptionField.text = "Paying \(self.output.name)";
        
        //set the the button name according to the amount
        if (self.output.amount >= 0){
            paymentButton.setTitle("Send Payment", forState: .Normal)
        }
        else {
            paymentButton.setTitle("Request Payment", forState: .Normal)
        }
        //decide the payment method here: api or app switch
        if (!Venmo.isVenmoAppInstalled()){
            Venmo.sharedInstance().defaultTransactionMethod = VENTransactionMethod.API
        }
        else {
            Venmo.sharedInstance().defaultTransactionMethod = VENTransactionMethod.AppSwitch
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
        var tempAmount = amountField.text.toInt()
        var amount: UInt
        if (tempAmount > 0){
            amount = UInt(tempAmount!)
        }
        else{
            amount = UInt(abs(tempAmount!))
        }
        var venmoId = venmoIdField.text
        var description = descriptionField.text
 
        Venmo.sharedInstance().requestPermissions(["make_payments","access_profile"], withCompletionHandler: {
            success, error in
            if success {
                //use Venmo to request a payemnt
                if (tempAmount! < 0){
                    
                    Venmo.sharedInstance().sendRequestTo(venmoId, amount: amount, note: description, completionHandler: { (transaction, success, error) -> Void in
                        if (success){
                            NSLog("Transaction succeeded!")
                        }
                        else{
                            NSLog("Transaction failed with error")
                            //println(error.localizedDescription)
                        }
                    })
                    
                    
                }
                    //to make a payment
                    
                else if (tempAmount! > 0){
                    Venmo.sharedInstance().sendPaymentTo(venmoId, amount: amount, note: description, completionHandler: { (transaction, success, error) -> Void in
                        if (success){
                            NSLog("Transaction succeeded!")
                        }
                        else{
                            NSLog("Transaction failed with error")
                            //println(error.localizedDescription)
                        }
                    })
                    
                    
                    
                }

                
            } else {
                println(error.localizedDescription)
            }
        })
                if (SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook)){
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
