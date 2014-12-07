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


class EventTableViewController: UITableViewController, UITableViewDataSource, SideBarDelegate {
    var sideBar: SideBar = SideBar()
    func sideBarDidSelectButtonAtIndex(index: Int) {
        
    }
    
    @IBAction func addFriendButton(sender: AnyObject) {
        var currentUser = PFUser.currentUser()
        var alert = UIAlertController(title: "Add Friend", message: "Please enter a username", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addTextFieldWithConfigurationHandler({(textField: UITextField!) in
            textField.placeholder = "Username"
            textField.secureTextEntry = false
            
            // Add button actions here
            var addBtnAction = UIAlertAction(title: "Add", style: UIAlertActionStyle.Default) {
                UIAlertAction in
                
                var text : String = textField.text
                
                println("I want to add the user: \(text)")
                
                var query = PFUser.query()
                query.whereKey("username", equalTo: text)
                query.getFirstObjectInBackgroundWithBlock {
                    (object: PFObject!, error: NSError!) -> Void in
                    if !(object != nil) {
                        NSLog("The getFirstObject request failed.")
                        //add alertView here later
                        
                    } else {
                        // The find succeeded.
                        NSLog("Successfully retrieved the object.")
                        //This can find username successfully
                        var friendsRelation : PFRelation = currentUser.relationForKey("friends")
                        friendsRelation.addObject(object);
                        currentUser.save()
                        
                    }
                }
            }
            
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
            alert.addAction(addBtnAction)
            self.presentViewController(alert, animated: true, completion: nil)
            
        })
    }
    var events : [AnyObject] = []
    
    
    override func viewDidLoad() {
        
        self.view.backgroundColor = UIColor(red: 237/255.0, green: 228/255.0, blue: 217/255.0, alpha: 1)

        super.viewDidLoad()
        var username: String;
        var email: String;
        var lastname: String;
        var firstname: String;
        
        var user = PFUser.currentUser()
        username = user.username
        email = user.email

        sideBar = SideBar(sourceView: self.view, menuItems: [username, email])
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            var fquery = PFUser.query();
            fquery.whereKey("friends", equalTo: user)
            var friends = fquery.findObjects();
            dispatch_sync(dispatch_get_main_queue(), {
                // update ui
            });
        });
        
        self.navigationItem.setHidesBackButton(true, animated: true);

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.updateEvents(PFUser.currentUser())
    }
    func updateEvents(user : PFUser) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            var query = PFQuery(className: "Event");
            query.whereKey("participants", equalTo: user);
            self.events = query.findObjects();
            dispatch_sync(dispatch_get_main_queue(), {
                self.tableView.reloadData()
            });
        });
    }
    
    @IBAction func onSync(sender: UIBarButtonItem) {
        self.updateEvents(PFUser.currentUser());
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("event") as? EventCellTableViewCell ?? EventCellTableViewCell()

        var event: AnyObject = self.events[indexPath.row]
        var dateCreated = event.createdAt
        var dateFormat = NSDateFormatter();
        dateFormat.dateFormat = "EEE, MMM d, h:mm a";
        cell.nameLabel.text = event["name"] as? String
        cell.dateLabel.text = NSString(format: "%@", dateFormat.stringFromDate(dateCreated))
        cell.dateLabel.sizeToFit();
        return cell
    }
    
    @IBAction func onAddEvent(sender: UIBarButtonItem) {
        self.performSegueWithIdentifier("eventToNewEvent", sender: sender);
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
        if (segue.identifier == "eventToEventDetail") {
            var selectedIndex = self.tableView.indexPathForSelectedRow();
            var detailController = segue.destinationViewController as EventDetailTableViewController;
            detailController.event = self.events[selectedIndex!.row] as PFObject;
            
        }

    }

    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
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
