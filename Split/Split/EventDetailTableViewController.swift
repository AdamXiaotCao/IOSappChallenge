//
//  EventDetailTableViewController.swift
//  Split
//
//  Created by Xiaotian Cao on 9/28/14.
//  Copyright (c) 2014 Xiaotian Cao. All rights reserved.
//

import UIKit
struct OutPut{
    var name: String
    var id: String
    var amount: Int
    var venmoId: String
}




class EventDetailTableViewController: UITableViewController {


    var event: PFObject = PFObject(className: "Event")
    var entries: [PFObject] = []
    var participants: [PFObject] = []
    var outputs : [OutPut] = []
    var query = PFUser.query()
    @IBOutlet var entriesTable: EventEntryUITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func updateEntries() {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            var query = PFQuery(className: "Entry");
            query.whereKey("event", equalTo: self.event);
            self.entries = query.findObjects() as [PFObject];
            dispatch_sync(dispatch_get_main_queue(), {
                self.tableView.reloadData()
            });
        });
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            var query = self.event.relationForKey("participants").query();
            self.participants = query.findObjects() as [PFObject];
        });
    }
    
    override func viewWillAppear(animated: Bool) {
        self.updateEntries();
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "eventDetailToNewEntry") {
            println("going to add new entry")
            var addController = segue.destinationViewController as AddEntryViewController;
            addController.participants = self.participants
            addController.event = self.event
            
        }
        if (segue.identifier == "toCheckout"){
            var overviewController = segue.destinationViewController as OverviewTableViewController
            overviewController.outputs = self.doCalculation()
            overviewController.entries = self.entries;
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        if (section == 0) {
            return 1;
        }
        return self.entries.count
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if (indexPath.section == 0) {
            return 180;
        } else {
            return 60;
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if (indexPath.section == 0) {
            let cell = tableView.dequeueReusableCellWithIdentifier("eventDetailCell", forIndexPath: indexPath) as EventDetailTableViewCell
            cell.nameLabel.text = self.event["name"] as? String;
            var dateFormat = NSDateFormatter();
            dateFormat.dateFormat = "EEE, MMM d, h:mm a";
            cell.dateLabel.text = NSString(format: "%@", dateFormat.stringFromDate(self.event.createdAt))
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("entryCell", forIndexPath: indexPath) as? EventEntryTableViewCell ?? EventEntryTableViewCell();
            var entry = self.entries[indexPath.row]
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                var query = PFUser.query();
                query.whereKey("objectId", equalTo: entry["payer"].objectId);
                var objs = query.findObjects()
                var person = query.findObjects()[0] as PFObject;
                dispatch_sync(dispatch_get_main_queue(), {
                    var firstName = person["firstName"] as String;
                    var lastName = person["lastName"] as String;
                    cell.payerLabel.text = "\(firstName) \(lastName)";
                });
            });
            var amount = entry["amount"] as Int;
            cell.amountLabel.text = "\(amount)";
            cell.commentLabel.text = entry["comment"] as? String;
            return cell
        }
    }
    private func doCalculation() -> [OutPut]{
       //TODO calculate the and put name and lable into a Ouput struct
        //output struct will be passed to overview controller throught segue
        var user = PFUser.currentUser();
        var userId = user.objectId;
        var map = Dictionary<String, OutPut>();
        for participant in self.participants {
            if (participant.objectId == userId) {
                continue;
            }
            var firstname = participant["firstName"] as String;
            var lastname = participant["lastName"] as String;
            map[participant.objectId] = OutPut(name:"\(firstname) \(lastname)", id:participant.objectId, amount:0, venmoId: participant["venmoId"] as String);
        }
        for participant in self.participants {
            if (participant.objectId == user.objectId) {
                continue;
            }
            var otherId = participant.objectId;
            for entry in self.entries {
                var payerId = entry["payer"].objectId;
                var dict: Dictionary<String, Int> = entry["breakdown"] as Dictionary<String, Int>;
                if (payerId == userId) { // participant pays you
                    map[otherId]!.amount -= dict[otherId]! as Int;
                } else if (payerId == otherId) { // you pay participant
                    map[otherId]!.amount += dict[userId]! as Int;
                }
            }
        }
        var result :[OutPut] = [];
        for (id, output) in map {
            result.append(output);
        }
        return result;
    }




    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView!, canEditRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

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
