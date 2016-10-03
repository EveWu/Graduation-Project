//
//  UserViewController.swift
//  beta0
//
//  Created by wu xiao yue on 3/19/16.
//  Copyright © 2016 eve. All rights reserved.
//

import UIKit

class UserTableViewController: UITableViewController{

	var name = "访客"
	var groupList = [["个人信息"],["测试记录","训练纪录"],["设置"]]
	
	var selectedRow: Int!
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
//		print("viewDidLoad")
		
//		self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier:"userCell")
//		tableView.delegate = self
//		tableView.dataSource = self
		
		//setStatusBarBackgroundColor(UIColor.whiteColor())
		
		//self.view.backgroundColor = purple2
		//tableView.backgroundColor = purple2
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
//		print("didReceiveMemoryWarning")
	}
	
	override func loadView() {
		super.loadView()
//		print("loadView")
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(true)
		tableView.reloadRowsAtIndexPaths([NSIndexPath.init(forRow: 0, inSection: 0)], withRowAnimation: UITableViewRowAnimation.None)
		
//		print("viewWillAppear")
		
	}
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(true)

//		print("viewDidAppear")
	}
	
	override func viewWillDisappear(animated: Bool) {
		super.viewWillDisappear(true)
//		print("viewWillDisappear")
	}
	
	override func	viewDidDisappear(animated: Bool) {
		super.viewDidDisappear(true)
//		print("viewDidDisappear")
	}
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell : UITableViewCell = tableView.dequeueReusableCellWithIdentifier("userCell", forIndexPath: indexPath) as UITableViewCell
		cell.textLabel?.text = self.groupList[indexPath.section][indexPath.row]
		//cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
		if indexPath.section == 0 {
			var image: UIImage?
			if userimage == nil {
				image = UIImage(named: "head")
			} else {
				image = userimage
			}
			
			if username == nil {
				username = "访客"
			}

			let reSizedImage = reSizeImage(image!, toSize: CGSize(width: 60, height: 60))
			cell.textLabel?.text = String(username!)
			cell.imageView?.image = reSizedImage
			
			//tableView.reloadData()
		}
		
		return cell
	}
	
	override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return self.groupList.count
	}
	
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.groupList[section].count
	}
	
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		print("click \(indexPath.section)  \(indexPath.row)")
		selectedRow = indexPath.row
		if indexPath.section == 0 {
			if indexPath.row == 0 {
				self.performSegueWithIdentifier("showInfo", sender: tableView)
				

			}
		}
		else if indexPath.section == 1 {
//			if indexPath.row == 0 {
//		
//			}
//			else if indexPath.row == 1 {
//				
//			}
			self.performSegueWithIdentifier("showRecord", sender: self)
		}
		else if indexPath.section == 2 {
			if indexPath.row == 0 {
				self.performSegueWithIdentifier("showSetting", sender: self)
			}
		}
		tableView.deselectRowAtIndexPath(indexPath, animated: false)
	}

	override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		if indexPath.section == 0 {
			return 88
		} else {
			return 44
		}
	}
	
	override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 22
	}
	
	override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		return 1
	}
	
	override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let view: UIView = UIView.init(frame: CGRectMake(0, 0, 320, 1))
		view.backgroundColor = UIColor.clearColor()
		return view
	}
	
	override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
		let view: UIView = UIView.init(frame: CGRectMake(0, 0, 320, 1))
		view.backgroundColor = UIColor.clearColor()
		return view
	}
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "showInfo" {
			
		} else if segue.identifier == "showRecord" {
			let secondViewController: RecordTableViewController = segue.destinationViewController as! RecordTableViewController
			
			// show test record
			if selectedRow == 0 {
				secondViewController.test = true
				
			} else {
				secondViewController.test = false
				
			}
		} else if segue.identifier == "showSetting" {
			
		}

	}

	
}

/*
class Cell: UITableViewCell {
	override func layoutSubviews() {
		self.imageView?.bounds = CGRectMake(0, 0, 20, 20)
		self.imageView?.frame = CGRectMake(0, 0, 20, 20)
		self.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
		
		var tmpFrame: CGRect = (self.textLabel?.frame)!
		tmpFrame.origin.x = 20
		self.textLabel?.frame = tmpFrame
		tmpFrame = (self.detailTextLabel?.frame)!
		tmpFrame.origin.x = 20
		self.detailTextLabel?.frame = tmpFrame
	}
}
*/
