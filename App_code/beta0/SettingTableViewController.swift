//
//  SettingViewController.swift
//  beta0
//
//  Created by wu xiao yue on 4/18/16.
//  Copyright © 2016 eve. All rights reserved.
//

import UIKit

class SettingTableViewController: UITableViewController{
	
	var groupList = [["账号管理", "修改密码"],["使用帮助","意见反馈","关于我们"],["退出登录"]]
	
	var alertController = UIAlertController(title: "", message: "退出后不会删除任何历史数据。", preferredStyle: UIAlertControllerStyle.ActionSheet)
	//let exitAction = UIAlertAction(title: "退出登录", style: UIAlertActionStyle.Destructive, handler: )

	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		//		print("viewDidLoad")
		
//		self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier:"settingCell")
//		tableView.delegate = self
//		tableView.dataSource = self
		let exitAction = UIAlertAction(title: "退出登录", style: UIAlertActionStyle.Destructive, handler: { (UIAlertAction) -> Void in
			self.clearUserDefaultsData()
			//self.performSegueWithIdentifier("showLogin", sender: self)
			//let loginViewController = LoginViewController()
			let storyboard = UIStoryboard(name: "Main", bundle: nil)
			let loginViewController = storyboard.instantiateViewControllerWithIdentifier("loginStoryboard") as! LoginViewController
			self.presentViewController(loginViewController, animated: true, completion: nil)
		})
		let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil)
		alertController.addAction(exitAction)
		alertController.addAction(cancelAction)
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
		let cell : UITableViewCell = tableView.dequeueReusableCellWithIdentifier("settingCell", forIndexPath: indexPath) as UITableViewCell
		cell.textLabel?.text = self.groupList[indexPath.section][indexPath.row]
		
		if indexPath.section == 2 {
			cell.accessoryType = UITableViewCellAccessoryType.None
			cell.textLabel?.textColor = UIColor.redColor()
			cell.textLabel?.textAlignment = NSTextAlignment.Center
		} else {
//			cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
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
		if indexPath.section == 0 {
			if indexPath.row == 0 {
				self.performSegueWithIdentifier("showAccount", sender: tableView)
			} else if indexPath.row == 1 {
				self.performSegueWithIdentifier("showModifyPassword", sender: self)
			}
		}
		else if indexPath.section == 1 {
			if indexPath.row == 0 {
				self.performSegueWithIdentifier("showHelp", sender: tableView)
			} else if indexPath.row == 1 {
				self.performSegueWithIdentifier("showFeedback", sender: self)
			} else if indexPath.row == 2 {
				self.performSegueWithIdentifier("showAbout", sender: self)
			}
		}
		else if indexPath.section == 2 {
			if indexPath.row == 0 {
				self.presentViewController(alertController, animated: true, completion: nil)
			}
		}
		tableView.deselectRowAtIndexPath(indexPath, animated: false)
	}
	
	override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return 44
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
	
	func clearUserDefaultsData() {
		let dic = userDefaults.dictionaryRepresentation()
		for key in dic {
			userDefaults.removeObjectForKey(key.0)
		}
		userDefaults.synchronize()
	}
	
	
}


