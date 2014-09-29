//
//  MakePaymentViewController.swift
//  Split
//
//  Created by Xiaotian Cao on 9/28/14.
//  Copyright (c) 2014 Xiaotian Cao. All rights reserved.
//

import UIKit

class MakePaymentViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
