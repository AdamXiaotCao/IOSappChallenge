//
//  EventTableViewController.swift
//  Split
//
//  Created by Xiaotian Cao on 9/27/14.
//  Copyright (c) 2014 Xiaotian Cao. All rights reserved.
//

import UIKit

struct Entry {
    var amount: Float
    var event: String
    var creator: String
    var payer: String
    
}

struct Event{
    var name: String
    var entries : [Entry]
    var participants: [User]

}

struct User{
    var userName: String
    var password: String
}

var adam = User(userName: "adam", password: "123")
var harry = User(userName: "harry", password: "1234")
var entry1 = Entry(amount: 10.5, event: "food", creator: "adam" , payer: "harry")
var entry2 = Entry(amount: 10.2, event: "coffee", creator: "harry" , payer: "harry")



class EventTableViewController: UITableViewController, UITableViewDataSource {

    var events : [Event] = [
        Event(name: "cali trip", entries: [entry1, entry2], participants: [adam,harry]),
        Event(name: "miami trip", entries: [entry1, entry2], participants: [adam,harry])
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var user = PFUser.currentUser();
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            var query = PFQuery(className: "Event");
            query.whereKey("participants", equalTo: user);
            var objects = query.findObjects();
            dispatch_sync(dispatch_get_main_queue(), {
                // update ui
            });
        });
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            var fquery = PFUser.query();
            fquery.whereKey("friends", equalTo: user)
            var friends = fquery.findObjects();
            dispatch_sync(dispatch_get_main_queue(), {
                // update ui
            });
        });
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("event") as? EventCellTableViewCell ?? EventCellTableViewCell()
        var event = self.events[indexPath.row]
        
        cell.nameLabel.text = event.name
        cell.dateLabel.text = "2014-09-09"
        
        return cell
        
    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // Uncomment the following line to preserve selection between presentations
//        // self.clearsSelectionOnViewWillAppear = false
//
//        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
//        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }

    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.events.count
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }



    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView!, canEditRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView!, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath!) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView!, moveRowAtIndexPath fromIndexPath: NSIndexPath!, toIndexPath: NSIndexPath!) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView!, canMoveRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
