//
//  TestResultViewController.swift
//  beta0
//
//  Created by wu xiao yue on 3/22/16.
//  Copyright © 2016 eve. All rights reserved.
//

import UIKit

class TestResultViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
	
	@IBOutlet weak var graphView: GraphView!
	@IBOutlet weak var pageControl: UIPageControl!
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var rightBarButton: UIBarButtonItem!
	@IBOutlet weak var timestamp: UILabel!
	@IBOutlet weak var imageView: UIImageView!
	
	var groupList = ["总轨迹长","平均速度","包络面积","单位面积轨迹长","x轴方向轨迹长","y轴方向轨迹长"]
	//,"动摇角度","能量损耗"
	var copArray = Array<Array<CGPoint>>(count: 4, repeatedValue: Array<CGPoint>())
	var polygon = Array<Array<CGPoint>>(count: 4, repeatedValue: Array<CGPoint>())
	var index = Array<Array<String>>(count: 4, repeatedValue: Array<String>(count: testIndexNumber, repeatedValue: String()))

	var newRecord = Array<Array<String>>()
	
	var imageList = Array<UIImage>(count: 4, repeatedValue: UIImage())
	
	var lng: Float!
	var mv: Float!
	var area: Float!
	var lng_a: Float!
	var lngx: Float!
	var lngy: Float!
	var currentTime: String!
	var customTitle: String!
	
	/* alert window */
	let alertController = UIAlertController(title: "用户未登录", message: "请前往个人信息登录", preferredStyle: UIAlertControllerStyle.Alert)
	let okAction = UIAlertAction(title: "好的", style: UIAlertActionStyle.Default, handler: nil)
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.

		
		alertController.addAction(okAction)
		
		getValue()
		
			let hidItem: UIBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: self, action: nil)
			self.navigationItem.setLeftBarButtonItem(hidItem, animated: false)
			rightBarButton.title = "保存"
			graphView.copArray = copArray[pageControl.currentPage]
			graphView.polygon = polygon[pageControl.currentPage]
		
		
		

		//getImageListFromView()
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
		getImageListFromView()
			submitTestRecord()
			submitTestImages()
	}
	@IBAction func pageChanged(sender: UIPageControl) {
			graphView.copArray = copArray[pageControl.currentPage]
			graphView.polygon = polygon[pageControl.currentPage]
			graphView.setNeedsDisplay()
		tableView.reloadData()
	}
	@IBAction func swipeRight(sender: UISwipeGestureRecognizer) {
		print("view right")
		if pageControl.currentPage > 0 {
			pageControl.currentPage = pageControl.currentPage - 1
			graphView.copArray = copArray[pageControl.currentPage]
			graphView.polygon = polygon[pageControl.currentPage]
			graphView.setNeedsDisplay()
			tableView.reloadData()
		}
	}
	@IBAction func swipeLeft(sender: UISwipeGestureRecognizer) {
		print("view left")
		if pageControl.currentPage < 3 {
			pageControl.currentPage  = pageControl.currentPage + 1
			graphView.copArray = copArray[pageControl.currentPage]
			graphView.polygon = polygon[pageControl.currentPage]
			graphView.setNeedsDisplay()
			tableView.reloadData()
		}
	}

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
				for var count = 0; count < copArray.count; count++ {
					var time: Float = 0.0
					// calculate H
					var H: Float = 0.0
					
					H = getH(userweight, height: Float(userheight), bust: Float(userbust), waist: Float(userwaist), hip: Float(userhip), sex: usersex)
					print("weight: \(userweight),height: \(userheight),bust: \(userbust),waist: \(userwaist),hip: \(userhip)")
					print("H: \(H)")
					if count <= 1 {
						time = 30
					} else {
						time = 15
					}
					polygon[count] = getPolygon(copArray[count])
					//copArray[count].removeLast()
					lng = getLng(copArray[count])
					mv = getMv(lng, t: time)
					area = getArea(polygon[count])
					lng_a = getLng_a(lng, area: area)
					lngx = getLngx(copArray[count])
					lngy = getLngy(copArray[count])
					
					index[count][0] = String(lng)
					index[count][1] = String(mv)
					index[count][2] = String(area)
					index[count][3] = String(lng_a)
					index[count][4] = String(lngx)
					index[count][5] = String(lngy)
					
					//index[count][6] = String(getDeg(copArray[count], H: H))
					//index[count][7] = String(getEng(copArray[count], H: H, weight: userweight))
					
				}
				// add time and title
				newRecord = index
				
				let now = NSDate()
				let dateFormatter = NSDateFormatter()
				dateFormatter.dateFormat = "yyyy-MM-dd-HH:mm:ss"
				currentTime = dateFormatter.stringFromDate(now)
				customTitle = currentTime
				
				timestamp.text = currentTime
				
				newRecord.append([currentTime, customTitle])
		}
		

	}
	
	func submitTestRecord() {
		var jsonRecord = NSData()
		var jsonRecordStr = String()
		
		let urlPath = "\(url_prefix)addTestRecord.php"
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
		let task = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
			if error != nil {
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
							testRecord.append(self.newRecord)
							userDefaults.setObject(testRecord, forKey: "testRecord")
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
	
	
	func submitTestImages() {
		let num = testRecord.count
		for var count = 0; count < 4; count++ {
			uploadImage("\(userid)-\(num)-\(count)", image: imageList[count])
		}
	}
	
	func getImageListFromView() {
		for var count = 0; count < 4; count++ {
			let currentView = graphView
			currentView.copArray = copArray[count]
			currentView.polygon = polygon[count]
			currentView.setNeedsDisplay()
			UIGraphicsBeginImageContextWithOptions(currentView.bounds.size, true, currentView.layer.contentsScale)
			currentView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
			let image = UIGraphicsGetImageFromCurrentImageContext()
			UIGraphicsEndImageContext()
			imageList[count] = image
			
		}
	}
	
	func uploadImage(imagename: String, image: UIImage){
//		var code = -1
		
		let boundary = "AaB03x"
		let imageData = UIImagePNGRepresentation(image)!
		
		let urlPath = "\(url_prefix)uploadImage.php"
		
		//print("usrlPath: \(urlPath)")
		let url = NSURL(string: urlPath)
		let session = NSURLSession.sharedSession()
		let request = NSMutableURLRequest(URL: url!)
		request.HTTPMethod = "POST"
		request.cachePolicy = NSURLRequestCachePolicy.ReloadRevalidatingCacheData
		let contentType = "multipart/form-data;charset=utf-8;boundary=\(boundary)"
		request.addValue(contentType, forHTTPHeaderField: "Content-Type")
		//let postBody = "id=\(userid)&imageData=\(imageData)"
		//request.HTTPBody = postBody.dataUsingEncoding(NSUTF8StringEncoding)
		
		let body = NSMutableData()
		body.appendData("\r\n--\(boundary)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
		body.appendData("Content-Disposition: form-data; name='userfile';filename='\(imagename).png'".dataUsingEncoding(NSUTF8StringEncoding)!)
		body.appendData("Content-Type: application/octet-stream\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
		body.appendData(imageData)
		body.appendData("\r\n--\(boundary)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
		request.HTTPBody = body
		// post
		let task = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
			if error != nil {
				print(error!.localizedDescription)
				print("session error: \(error!.code)")
				//code = (error?.code)!
			} else {
				//let result = NSString(data: data!, encoding: NSUTF8StringEncoding)
				
				//print("result: \(result)")
				//print("start json decode")
				// json decode
				do {
					let jsonResult = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)
					//print("json result: \(jsonResult)")
					let status = jsonResult.objectForKey("status") as! Int
					print("status: \(status)")
					if status == 0 {
//						code = 0
						print("upload image successfully")
					}
				} catch {
					print("json error")
				}
			}
		}
		task.resume()

	}
	
}










