//
//  EventEntryUITableView.swift
//  Split
//
//  Created by Xiaotian Cao on 9/28/14.
//  Copyright (c) 2014 Xiaotian Cao. All rights reserved.
//

import UIKit

class EventEntryUITableView: UITableView, UITableViewDataSource {

    var entries: [PFObject] = []

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect)
    {
        // Drawing code
    }
    */
  
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        println("S")
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        println(self.entries.count)
        return self.entries.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        println("view")
        var cell = tableView.dequeueReusableCellWithIdentifier("entryCell", forIndexPath: indexPath) as EventEntryTableViewCell
        var entry = self.entries[indexPath.row]
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            var query = PFUser.query();
            query.whereKey("objectId", equalTo: entry.objectId);
            var person = query.findObjects()[0] as PFObject;
            dispatch_sync(dispatch_get_main_queue(), {
                cell.payerLabel.text = person["firstName"] as? String;
            });
        });
        cell.amountLabel.text = entry["amount"] as? String
        cell.commentLabel.text = entry["comment"] as? String
        return cell
    }

}
