//
//  Events.swift
//  Split
//
//  Created by NepTune on 17/12/14.
//  Copyright (c) 2014 Xiaotian Cao. All rights reserved.
//

import UIKit

class Events: UIViewController, UITableViewDataSource{
    let cellIdentifier = "PTRCellIdentifier"
    let favoriteAnimals = ["cat", "dog","fish"]
    let newFavorietAnimals = ["elephants", "bugs", "bird"]
    var tableData = [String]()
    var tableViewController = UITableViewController(style: UITableViewStyle.Plain)
    var refreshControl = UIRefreshControl()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableData = favoriteAnimals
        var tableView = tableViewController.tableView
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.dataSource = self
        tableViewController.refreshControl = self.refreshControl
        self.refreshControl.addTarget(self, action: "didRefreshList", forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl.backgroundColor = UIColor.grayColor()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Last updated on \(NSDate())")
        self.view.addSubview(tableView)

        // Do any additional setup after loading the view.
    }
    func didRefreshList() {
        self.tableData = newFavorietAnimals
        self.tableViewController.tableView.reloadData()
        self.refreshControl.endRefreshing()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as UITableViewCell
        cell.textLabel?.text = self.tableData[indexPath.row]
        return cell
        
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
