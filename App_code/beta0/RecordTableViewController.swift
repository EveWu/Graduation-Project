//
//  TestRecord.swift
//  beta0
//
//  Created by wu xiao yue on 4/16/16.
//  Copyright © 2016 eve. All rights reserved.
//

import UIKit

class RecordTableViewController: UITableViewController{
	var groupList = Array<String>()
	//var groupList = ["个人信息"]
	var test: Bool!
	var selectedRow: Int!
	
	@IBOutlet var recordTableView: UITableView!
	var deleteIndexpath: NSIndexPath!
	
	var alertController = UIAlertController(title: "删除出错", message: "服务器删除数据出错", preferredStyle: UIAlertControllerStyle.Alert)
	let okAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.Default, handler: nil)
	
	func initRecord() {
		if test == true {
			for count in 0..<testRecord.count {
				groupList.append(testRecord[count][4][1])
			}
		} else {
			for count in 0..<trainingRecord.count {
				groupList.append(trainingRecord[count][6])
			}
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier:"recordCell")
		tableView.delegate = self
		tableView.dataSource = self
		initRecord()
		//tableView.re
		print(groupList);
		alertController.addAction(okAction)
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		//tableView.reloadData()
	}
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		//tableView.reloadData()
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell : UITableViewCell = tableView.dequeueReusableCellWithIdentifier("recordCell", forIndexPath: indexPath) as UITableViewCell
		cell.textLabel?.text = self.groupList[indexPath.row]
		cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
		return cell
	}
	
	override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.groupList.count
	}
	
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		print("click row: \(indexPath.row)")
		selectedRow = indexPath.row
		
		if test == true {
			performSegueWithIdentifier("showTestRecord", sender: self)
		} else {
			performSegueWithIdentifier("showTrainingRecord", sender: self)
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
	
	override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
		if editingStyle == UITableViewCellEditingStyle.Delete {
			deleteIndexpath = indexPath
			if test == true {
				deleteTestRecord(indexPath.row)
				testRecord.removeAtIndex(indexPath.row)
			} else {
				deleteTrainingRecord(indexPath.row)
				trainingRecord.removeAtIndex(indexPath.row)
			}
			groupList.removeAtIndex(indexPath.row)
			//tableView.reloadData()
			tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
		}
	}
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "showTestRecord" {
			let secondViewController: TestRecordViewController = segue.destinationViewController as! TestRecordViewController
			secondViewController.row = selectedRow
		} else if segue.identifier == "showTrainingRecord" {
			let secondViewController: TrainingResultViewController = segue.destinationViewController as! TrainingResultViewController
			secondViewController.training = false
			secondViewController.row = selectedRow
			
//			secondViewController.timePassed = Int(trainingRecord[selectedRow][0])
//			secondViewController.timeUsedLeast = Int(trainingRecord[selectedRow][2])
//			secondViewController.timeUsedMost = Int(trainingRecord[selectedRow][3])
//			secondViewController.failNumber = Int(trainingRecord[selectedRow][4])
//			secondViewController.successNumber = Int(trainingRecord[selectedRow][5])
		}
	}
	
	func deleteTestRecord(row: Int){
		let timestamp = testRecord[row][4][0]
		let urlPath = "\(url_prefix)deleteTestRecord.php?id=\(userid)&timestamp=\(timestamp)"
		print("usrlPath: \(urlPath)")
		let url = NSURL(string: urlPath)
		let session = NSURLSession.sharedSession()
		let request = NSURLRequest(URL: url!)
		print("start session")
		// get
		let task = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
			if error != nil {
				print(error!.localizedDescription)
				print("session error: \(error!.code)")
			} else {
				let result = NSString(data: data!, encoding: NSUTF8StringEncoding)
				print("result: \(result)")
				//print("start json decode")
				// json decode
				do {
					let jsonResult = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)
					print("json result: \(jsonResult)")
					let status = jsonResult.objectForKey("status") as! Int
					
					//print("status: \(status)")

					if status == 0 {
						print("delete success")

					} else {
						print("delete error")
					}
					
				} catch {
					print("json error")
				}
			}
		}
		task.resume()
	}
	
	func deleteTrainingRecord(row: Int){
		let timestamp = trainingRecord[row][6]
		let urlPath = "\(url_prefix)deleteTrainingRecord.php?id=\(userid)&timestamp=\(timestamp)"
		print("usrlPath: \(urlPath)")
		let url = NSURL(string: urlPath)
		let session = NSURLSession.sharedSession()
		let request = NSURLRequest(URL: url!)
		print("start session")
		// get
		let task = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
			if error != nil {
				print(error!.localizedDescription)
				print("session error: \(error!.code)")
			} else {
				let result = NSString(data: data!, encoding: NSUTF8StringEncoding)
				print("result: \(result)")
				//print("start json decode")
				// json decode
				do {
					let jsonResult = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)
					print("json result: \(jsonResult)")
					let status = jsonResult.objectForKey("status") as! Int
					
					//print("status: \(status)")
					
					if status == 0 {
						print("delete success")
					} else {
						print("delete error")
					}
					
					
				} catch {
					print("json error")
				}
			}
		}
		task.resume()
	}
	


}

