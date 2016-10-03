//
//  TrainingResultViewController.swift
//  beta0
//
//  Created by wu xiao yue on 4/4/16.
//  Copyright © 2016 eve. All rights reserved.
//

import UIKit

class TrainingResultViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
	var successNumber: Int!
	var failNumber: Int!
	var timePassed: Int!
	var timeUsedLeast: Int!
	var timeUsedMost: Int!
	var groupList = [["总持续时间","平均时间","最少花时","最多花时","失败个数"]]
	var index = Array<String>(count: 5, repeatedValue: String())
	var training: Bool!
	var row: Int!
	var newRecord = Array<String>()
	
	var currentTime: String!
	var customTitle: String!
	
	@IBOutlet weak var successNumberText: UILabel!
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var rightBarButton: UIBarButtonItem!
	@IBOutlet weak var timestamp: UILabel!
	
	
	/* alert window */
	let alertController = UIAlertController(title: "用户未登录", message: "请前往个人信息登录", preferredStyle: UIAlertControllerStyle.Alert)
	let okAction = UIAlertAction(title: "好的", style: UIAlertActionStyle.Default, handler: nil)
	

	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.

		
		alertController.addAction(okAction)
		getIndex()
		successNumberText.text = String(successNumber)
		
		
		//setStatusBarBackgroundColor(UIColor.whiteColor())
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		self.navigationController?.setNavigationBarHidden(false, animated: animated)
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	@IBAction func completePressed(sender: UIBarButtonItem) {
		if training == true {
			submitTrainingRecord()
			//self.navigationController?.popToRootViewControllerAnimated(true)
		}
		
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell : UITableViewCell = tableView.dequeueReusableCellWithIdentifier("indexCell", forIndexPath: indexPath) as UITableViewCell
		cell.textLabel?.text = self.groupList[indexPath.section][indexPath.row]
		let temp = index[indexPath.row]
		cell.detailTextLabel?.text = temp
		//cell.textLabel?.text = self.groupList[indexPath.section][indexPath.row]
		//cell.accessoryType = UITableViewCellAccessoryType.
		return cell
	}
	
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return self.groupList.count
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.groupList[section].count
	}
	
	func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 22
	}
	
	func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		return 1
	}
	
	func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let view: UIView = UIView.init(frame: CGRectMake(0, 0, 320, 1))
		view.backgroundColor = UIColor.clearColor()
		return view
	}
	
	func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
		let view: UIView = UIView.init(frame: CGRectMake(0, 0, 320, 1))
		view.backgroundColor = UIColor.clearColor()
		return view
	}
	
	func getIndex() {
		
		if training == true {
			rightBarButton.title = "保存"
			let hidItem: UIBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: self, action: nil)
			self.navigationItem.setLeftBarButtonItem(hidItem, animated: false)
			
			let minute = timePassed / 60
			if minute == 0 {
				index[0] = String(timePassed) + "秒"
			} else {
				let second = timePassed % 60
				index[0] = String(minute) + "分" + String(second) + "秒"
			}
			let meanTime = timePassed / (successNumber + failNumber)
			index[1] = String(meanTime) + "秒"
			index[2] = String(timeUsedLeast) + "秒"
			index[3] = String(timeUsedMost) + "秒"
			index[4] = String(failNumber)
			
			newRecord = index
			newRecord.append(String(successNumber))
			
			let now = NSDate()
			let dateFormatter = NSDateFormatter()
			dateFormatter.dateFormat = "yyyy-MM-dd-HH:mm:ss"
			let currentTime = dateFormatter.stringFromDate(now)
			let customTitle = currentTime
			
			timestamp.text = currentTime
			
			newRecord.append(currentTime)
			newRecord.append(customTitle)
			
			
			
		} else {
			rightBarButton.title = ""
			successNumber = Int(trainingRecord[row][5])
			
			for count in 0..<5 {
				index[count] = trainingRecord[row][count]
			}
			
			
			currentTime = trainingRecord[row][6]
			customTitle = trainingRecord[row][7]
			
			timestamp.text = currentTime
			self.navigationController?.navigationItem.title = customTitle
		}
		
	}
	
	func submitTrainingRecord() {
		
		var jsonRecord = NSData()
		var jsonRecordStr = String()
		
		let urlPath = "\(url_prefix)addTrainingRecord.php"
		//print("usrlPath: \(urlPath)")
		let url = NSURL(string: urlPath)
		let session = NSURLSession.sharedSession()
		let request = NSMutableURLRequest(URL: url!)
		request.HTTPMethod = "POST"
		
		
		
		do {
			jsonRecord = try NSJSONSerialization.dataWithJSONObject(newRecord, options: NSJSONWritingOptions.PrettyPrinted)
			print("jsonRecord: \(jsonRecord)")
			jsonRecordStr = String(data: jsonRecord, encoding: NSUTF8StringEncoding)!
			print("jsonRecordString: \(jsonRecordStr)")
		} catch {
			print("convert to json error")
		}
		//let postBody = "id=\(userid)&lng=\(lng)&mv=\(mv)&area=\(area)&lng_a=\(lng_a)&lngx=\(lngx)&lngy=\(lngy)&timestamp=\(currentTime)&title=\(customTitle)"
		//request.HTTPBody = postBody.dataUsingEncoding(NSUTF8StringEncoding)
		//let postBody = "id=\(userid)&record=\(newRecord)"
		let body = NSMutableData()
		body.appendData("id=\(userid)".dataUsingEncoding(NSUTF8StringEncoding)!)
		body.appendData("&record=\(jsonRecordStr)".dataUsingEncoding(NSUTF8StringEncoding)!)
		request.HTTPBody = body
		
		print("start info session")
		// get
		//session.d
		let task = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
			if error != nil {
				//if error.l
				print(error!.localizedDescription)
				print("info session error: \(error!.code)")
				dispatch_sync(dispatch_get_main_queue(), { () -> Void in
					// The Internet connection appears to be offline
					if error!.code == -1009 {
						self.alertController.message = "网络未连接，服务器端数据将不会被更改"
						self.presentViewController(self.alertController, animated: true, completion: nil)
					}
				})
			} else {
				let result = NSString(data: data!, encoding: NSUTF8StringEncoding)
				
				print("result: \(result)")
				//print("start json decode")
				// json decode
				do {
					let jsonResult = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)
					print("json result: \(jsonResult)")
					let status = jsonResult.objectForKey("status") as! Int
					print("status: \(status)")
					dispatch_sync(dispatch_get_main_queue(), { () -> Void in
						if status == 0 {
							trainingRecord.append(self.newRecord)
							userDefaults.setObject(testRecord, forKey: "trainingRecord")
							self.navigationController?.popToRootViewControllerAnimated(true)
						} else {
							self.alertController.message = "错误代码： \(status)"
							self.presentViewController(self.alertController, animated: true, completion: nil)
						}
						
					})
					
				} catch {
					print("info json error")
				}
			}
		}
		task.resume()
	}

	
}