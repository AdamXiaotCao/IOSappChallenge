//
//  EventEntryUITableView.swift
//  Split
//
//  Created by Xiaotian Cao on 9/28/14.
//  Copyright (c) 2014 Xiaotian Cao. All rights reserved.
//

import UIKit

class EventEntryUITableView: UITableView, UITableViewDataSource {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect)
    {
        // Drawing code
    }
    */
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var table = EventCellTableViewCell()
        return table
    }

}
