//
//  FriendsTableViewController.swift
//  Split
//
//  Created by Xiaotian Cao on 9/27/14.
//  Copyright (c) 2014 Xiaotian Cao. All rights reserved.
//

import UIKit

struct Friend {
    var first_name: String
    var last_name: String
}


class FriendsTableViewController: UITableViewController, UITableViewDataSource {
    
    
    var selectedCells = Dictionary<String, PFUser>()
    var friends: [PFUser] = []
    var parent: NewEventViewController = NewEventViewController()

    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        PFUser.logInWithUsername("harry", password: "123")
        
        var user = PFUser.currentUser()
        var query = user.relationForKey("friends").query()
        self.friends = query.findObjects() as [PFUser]
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    // MARK: - Table view data source



    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return self.friends.count
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedCell = tableView.cellForRowAtIndexPath(indexPath) as FriendTableViewCell
        
        let objId = friends[indexPath.row].objectId
        if (selectedCells[objId] != nil){
            selectedCell.accessoryType = .None
            selectedCells.removeValueForKey(objId)
            
        }else{
            selectedCell.accessoryType = .Checkmark
            selectedCells[objId] = friends[indexPath.row]
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        
        
    
        
        
    }
    

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("friend") as? FriendTableViewCell ?? FriendTableViewCell()
        var friend: AnyObject = self.friends[indexPath.row]
        
 
        cell.firstNameLabel.text = friend["firstName"] as? String

        cell.lastNameLabel.text = friend["lastName"] as? String
    
     
        if (selectedCells[friend.objectId] != nil){
            cell.accessoryType = .Checkmark
        }else{
            cell.accessoryType = .None
        }
        cell.firstNameLabel.sizeToFit()
        cell.lastNameLabel.sizeToFit()
        return cell
    }

    

    
 

    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView!, canEditRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    
    private func error(message: String) {
        var alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }

    
    @IBAction func onCreate(sender: AnyObject) {
        
        if (selectedCells.isEmpty){
            self.error("you need to choose friends to add")
            return
        }
        
        for (objId,friend) in selectedCells{
            friends.append(friend)
        }
        parent.friends = self.friends
        
            self.navigationController?.popViewControllerAnimated(true)
            
    
    }
        //still need to work on the back end
        
        
    
//    @IBAction func onCreate(sender: UIButton) {
//        if (self.nameField.text.isEmpty) {
//            self.error("Name cannot be empty");
//        } else {
//            var newEvent = PFObject(className: "Event");
//            newEvent["name"] = self.nameField.text;
//            var participants = newEvent.relationForKey("participants")
//            participants.addObject(PFUser.currentUser());
//            // TODO add friends
//            newEvent.saveInBackgroundWithBlock {
//                (succeeded: Bool!, error: NSError!) -> Void in
//                if error == nil {
//                    self.navigationController?.popViewControllerAnimated(true);
//                } else {
//                    self.error("Failed to create event");
//                }
//            }
//        }
//    }


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
