//
//  SideBar.swift
//  Split
//
//  Created by Xiaotian Cao on 9/27/14.
//  Copyright (c) 2014 Xiaotian Cao. All rights reserved.
//

import UIKit

@objc protocol SideBarDelegate{
    func sideBarDidSelectButtonAtIndex(index:Int)
    optional func sideBarWillClose() //optional can only apply to objective c
    optional func sideBarWIllOpen()
}//access objective C code

class SideBar: NSObject, SideBarTableViewControllerDelegate {
    
    let barWidth:CGFloat = 150.0
    let sideBarTableViewTopInset:CGFloat = 64 //pixel
    let sideBarContainerView:UIView = UIView()
    let sideBarTableViewController: SideBarTableViewController=SideBarTableViewController()
    let originView:UIView!
    var animator:UIDynamicAnimator! //animate the slide
    var delegate:SideBarDelegate?
    var isSideBarOpen:Bool = false
    
    override init(){
        super.init()
    }
    init(sourceView:UIView, menuItems:Array<String>){
        super.init()
        originView = sourceView
        sideBarTableViewController.tableData = menuItems
        setupSideBar()
        animator = UIDynamicAnimator(referenceView: originView)
        
        let showGestureRecognizer:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action:"handleSwipe:")
        showGestureRecognizer.direction = UISwipeGestureRecognizerDirection.Right
        originView.addGestureRecognizer(showGestureRecognizer)
        
        let hideGestureRecognizer:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action:"handleSwipe")
        
        hideGestureRecognizer.direction = UISwipeGestureRecognizerDirection.Left
        originView.addGestureRecognizer(hideGestureRecognizer)
        
    }
    //need some initializer
    func setupSideBar(){
        sideBarContainerView.frame = CGRectMake(-barWidth - 1, originView.frame.origin.y, barWidth, originView.frame.size.height)
        sideBarContainerView.backgroundColor = UIColor.clearColor()
        sideBarContainerView.clipsToBounds = false
        
        //add sibar container view to the origin view
        originView.addSubview(sideBarContainerView)
        let blurView:UIVisualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.Light))
        
        //give this view a frame
        
        blurView.frame = sideBarContainerView.bounds
        sideBarContainerView.addSubview(blurView)
        
        sideBarTableViewController.delegate = self
        sideBarTableViewController.tableView.frame = sideBarContainerView.bounds
        sideBarTableViewController.tableView.clipsToBounds = false
        sideBarTableViewController.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
    }
    
    
    func SideBarControlDidSelectRow(indexPath: NSIndexPath) {
        
    }
    
}