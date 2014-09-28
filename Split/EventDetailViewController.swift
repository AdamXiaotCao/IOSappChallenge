//
//  EventDetailViewController.swift
//  Split
//
//  Created by Xiaotian Cao on 9/27/14.
//  Copyright (c) 2014 Xiaotian Cao. All rights reserved.
//

import UIKit

class EventDetailViewController: UIViewController {

    var event: PFObject = PFObject(className: "Event")
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    
    @IBOutlet var entriesTable: EventEntryUITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.nameLabel.text = self.event["name"] as? String
        self.nameLabel.sizeToFit()
        var dateFormat = NSDateFormatter();
        dateFormat.dateFormat = "EEE, MMM d, h:mm a";
        self.dateLabel.text = NSString(format: "%@", dateFormat.stringFromDate(self.event.createdAt))
        self.dateLabel.sizeToFit()
        // Do any additional setup after loading the view.
    }

    func updateEntries() {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            var query = PFQuery(className: "Entry");
            query.whereKey("event", equalTo: self.event);
            self.entriesTable.entries = query.findObjects() as [PFObject];
            dispatch_sync(dispatch_get_main_queue(), {
                self.entriesTable.reloadData()
            });
        });
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
