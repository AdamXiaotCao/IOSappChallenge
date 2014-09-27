//
//  LoginViewController.swift
//  Split
//
//  Created by Xiaotian Cao on 9/27/14.
//  Copyright (c) 2014 Xiaotian Cao. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
            switch segue.identifier {
            case "tableToDisplay":
                if var secondViewController = segue.destinationViewController as? ReminderDisplayViewController {
                    if var cell = sender as? ReminderCellTableViewCell {
                        secondViewController.titleString = cell.reminderTitle.text!
                        secondViewController.dateString = cell.reminderDate.text!
                    }
                }
            default:
                break
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
