//
//  TestRecordViewController.swift
//  beta0
//
//  Created by wu xiao yue on 4/18/16.
//  Copyright © 2016 eve. All rights reserved.
//

import UIKit

class TestRecordViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
	
	@IBOutlet weak var pageControl: UIPageControl!
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var timestamp: UILabel!
	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var titleName: UINavigationItem!
	
	var groupList = ["总轨迹长","平均速度","包络面积","单位面积轨迹长","x轴方向轨迹长","y轴方向轨迹长"]
	//,"动摇角度","能量损耗"
	var index = Array<Array<String>>(count: 4, repeatedValue: Array<String>(count: testIndexNumber, repeatedValue: String()))
	var row: Int!
	
	var imageList = Array<UIImage>(count: 4, repeatedValue: UIImage())
	
	
	/* alert window */
	let alertController = UIAlertController(title: "用户未登录", message: "请前往个人信息登录", preferredStyle: UIAlertControllerStyle.Alert)
	let okAction = UIAlertAction(title: "好的", style: UIAlertActionStyle.Default, handler: nil)
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		
		
		alertController.addAction(okAction)
		
			
//			let swipeleft = UISwipeGestureRecognizer(target: self, action: "swipeAction")
//			swipeleft.direction = UISwipeGestureRecognizerDirection.Left
//			imageView.addGestureRecognizer(swipeleft)
//			let swiperight = UISwipeGestureRecognizer(target: self, action: "swipeAction")
//			swiperight.direction = UISwipeGestureRecognizerDirection.Right
//			imageView.addGestureRecognizer(swiperight)
//		
//			getImageList("\(userid)-\(self.row)-0", count: 0)
		getImageList("\(userid)-\(self.row)-0", count: 0)
		getValue()
		
		
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
	
	@IBAction func pageChanged(sender: UIPageControl) {

			imageView.image = imageList[pageControl.currentPage]
		tableView.reloadData()
	}

	
//	func swipeAction(sender: UISwipeGestureRecognizer) {
//		print("swipe action")
//		let direction = sender.direction
//		if direction == UISwipeGestureRecognizerDirection.Left {
//			print("image left")
//			if pageControl.currentPage < 3 {
//				pageControl.currentPage  = pageControl.currentPage + 1
//				imageView.image = imageList[pageControl.currentPage]
//				tableView.reloadData()
//			}
//		} else if direction == UISwipeGestureRecognizerDirection.Right {
//			print("image right")
//			if pageControl.currentPage > 0 {
//				pageControl.currentPage = pageControl.currentPage - 1
//				imageView.image = imageList[pageControl.currentPage]
//				tableView.reloadData()
//			}
//		}
//	}
	
//	@IBAction func swipeRight(sender: UISwipeGestureRecognizer) {
//		print("image right")
//		if pageControl.currentPage > 0 {
//			pageControl.currentPage = pageControl.currentPage - 1
//			imageView.image = imageList[pageControl.currentPage]
//			tableView.reloadData()
//		}
//	}
//	
//	@IBAction func swipeLeft(sender: UISwipeGestureRecognizer) {
//		print("image left")
//		if pageControl.currentPage < 3 {
//			pageControl.currentPage  = pageControl.currentPage + 1
//			imageView.image = imageList[pageControl.currentPage]
//			tableView.reloadData()
//		}
//	}
	
	@IBAction func swipeLeft(sender: UISwipeGestureRecognizer) {
				print("image left")
				if pageControl.currentPage < 3 {
					pageControl.currentPage  = pageControl.currentPage + 1
					imageView.image = imageList[pageControl.currentPage]
					tableView.reloadData()
				}
	}
	@IBAction func swipeRight(sender: UISwipeGestureRecognizer) {
				print("image right")
				if pageControl.currentPage > 0 {
					pageControl.currentPage = pageControl.currentPage - 1
					imageView.image = imageList[pageControl.currentPage]
					tableView.reloadData()
				}
	}
	//	@IBAction func swipeRightImage(sender: UISwipeGestureRecognizer) {
	//		print("image right")
	//		if pageControl.currentPage > 0 {
	//			pageControl.currentPage = pageControl.currentPage - 1
	//			imageView.image = imageList[pageControl.currentPage]
	//			tableView.reloadData()
	//		}
	//	}
	//
	//	@IBAction func swipeLeftImage(sender: UISwipeGestureRecognizer) {
	//		print("image left")
	//		if pageControl.currentPage < 3 {
	//			pageControl.currentPage  = pageControl.currentPage + 1
	//			imageView.image = imageList[pageControl.currentPage]
	//			tableView.reloadData()
	//		}
	//	}
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell : UITableViewCell = tableView.dequeueReusableCellWithIdentifier("indexCell", forIndexPath: indexPath) as UITableViewCell
		cell.textLabel?.text = self.groupList[indexPath.row]
		let temp = index[pageControl.currentPage][indexPath.row]
		cell.detailTextLabel?.text = String(temp)
		//cell.textLabel?.text = self.groupList[indexPath.section][indexPath.row]
		//cell.accessoryType = UITableViewCellAccessoryType.
		return cell
	}
	
	func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		if section == 0 {
			return "睁眼双脚"
		} else if section == 1 {
			return "闭眼双脚"
		} else if section == 2 {
			return "睁眼单脚"
		} else if section == 3 {
			return "闭眼单脚"
		}
		return "不存在"
	}
	
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.groupList.count
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
	
	func getValue() {
		if username == nil {
			self.presentViewController(alertController, animated: true, completion: nil)
		} else {
			for var count = 0; count < 4; count++ {
				let temp = testRecord[row][count]
				index[count] = temp
			}
//				index = testRecord[row]
				let currentTime = testRecord[row][4][0]
				let customTitle = testRecord[row][4][1]
				
				timestamp.text = currentTime
				titleName.title = customTitle
		}
		
		
	}

	
	func getImageList(imagename: String, count: Int){
		//	var image = UIImage()
		
		let urlPath = "\(url_prefix)picture/\(imagename).png"
		print("usrlPath: \(urlPath)")
		let url = NSURL(string: urlPath)
		let session = NSURLSession.sharedSession()
		let request = NSURLRequest(URL: url!)
		//print("start session")
		// get
		let task = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
			//		dispatch_sync(dispatch_get_main_queue(), { () -> Void in
			if error != nil {
				//if error.l
				print(error!.localizedDescription)
				print("session error: \(error!.code)")
			} else {
				
				//let result = NSString(data: data!, encoding: NSUTF8StringEncoding)
				//print("result: \(result)")
				if data != nil {
					//					userimageData = data
					//					userimage = UIImage(data: userimageData)
					let image = UIImage(data: data!)!
					self.imageList[count] = image
					
					print("get image \(count)")
					
					if count == 3 {
						self.imageView.image = self.imageList[self.pageControl.currentPage]
					} else {
						self.getImageList("\(userid)-\(self.row)-\(count+1)", count: count+1)
					}
				}
				
			}
			//		})
			
		}
		task.resume()
		//	return image
	}
		
}
