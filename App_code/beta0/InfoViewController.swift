//
//  InfoViewController.swift
//  beta0
//
//  Created by wu xiao yue on 3/19/16.
//  Copyright © 2016 eve. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
	
	@IBOutlet weak var changeImage: UIButton!
	@IBOutlet weak var name: UITextField!
	@IBOutlet weak var sex: UISegmentedControl!
	@IBOutlet weak var age: UIPickerView!
	@IBOutlet weak var height: UIPickerView!
	@IBOutlet weak var weight: UIPickerView!
	@IBOutlet weak var weight_fraction: UIPickerView!
	@IBOutlet weak var bust: UIPickerView!
	@IBOutlet weak var waist: UIPickerView!
	@IBOutlet weak var hip: UIPickerView!

	@IBOutlet weak var nameAlert: UIImageView!
	
	@IBOutlet weak var blackView: UIView!
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var scrollView: UIScrollView!
	
	var alertController = UIAlertController(title: "修改出错", message: "用户名已存在", preferredStyle: UIAlertControllerStyle.Alert)
	let okAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.Default, handler: nil)
	
	private var imagePicker: UIImagePickerController!
	
	private var groupList = [["拍照","从手机相册选择"],["取消"]]
	
	var window: UIWindow!
	
	func initInfo() {
		
		//scrollView.contentSize = CGSizeMake(0, 900)
		

		
		nameAlert.hidden = true
		
		name.placeholder = "姓名"
		name.textAlignment = NSTextAlignment.Center
		sex.selectedSegmentIndex = 1
		
		tableView.hidden = true
		tableView.alpha = 1
		self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier:"chooseCell")
		tableView.delegate = self
		tableView.dataSource = self
		//tableView.backgroundColor = UIColor.whiteColor()
		//tableView.alpha = 1
		
		
		blackView.backgroundColor = UIColor.grayColor()
		blackView.alpha = 0.5
		blackView.hidden = true
		
		name.delegate = self
		
		age.delegate = self
		age.dataSource = self
		height.delegate = self
		height.dataSource = self
		weight.delegate = self
		weight.dataSource = self
		
		if username == "访客" {
			changeImage.setBackgroundImage(UIImage(named: "head"), forState: UIControlState.Normal)
			age.selectRow(30, inComponent: 0, animated: true)
			height.selectRow(160, inComponent: 0, animated: true)
			weight.selectRow(55, inComponent: 0, animated: true)
			weight_fraction.selectRow(0, inComponent: 0, animated: true)
			bust.selectRow(80, inComponent: 0, animated: true)
			waist.selectRow(70, inComponent: 0, animated: true)
			hip.selectRow(80, inComponent: 0, animated: true)
		} else {

			changeImage.setBackgroundImage(userimage, forState: UIControlState.Normal)
			name.text = username
			sex.selectedSegmentIndex = usersex
			age.selectRow(userage, inComponent: 0, animated: true)
			height.selectRow(userheight, inComponent: 0, animated: true)
			weight.selectRow(userweight_main, inComponent: 0, animated: true)
			weight_fraction.selectRow(userweight_fraction, inComponent: 0, animated: true)
			bust.selectRow(userbust, inComponent: 0, animated: true)
			waist.selectRow(userwaist, inComponent: 0, animated: true)
			hip.selectRow(userhip, inComponent: 0, animated: true)
		}
		
		

		
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		
		initInfo()
		
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(false)
		scrollView.contentSize = CGSizeMake(0, 900)
	}
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(false)
		scrollView.contentSize = CGSizeMake(0, 700)
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


	
	@IBAction func donePressed(sender: UIBarButtonItem) {
		userimage = changeImage.backgroundImageForState(UIControlState.Normal)
		username = name.text!
		usersex = sex.selectedSegmentIndex
		userage = age.selectedRowInComponent(0)
		userheight = height.selectedRowInComponent(0)
		userweight_main = weight.selectedRowInComponent(0)
		userweight_fraction = weight_fraction.selectedRowInComponent(0)
		userweight = Float(userweight_main) + Float(userweight_fraction) * Float(0.1)
		userbust = bust.selectedRowInComponent(0)
		userwaist = waist.selectedRowInComponent(0)
		userhip = hip.selectedRowInComponent(0)
		//var userage = age.s
		
		if username == ""{
			nameAlert.hidden = false
			print("请输入名字")
		} else {
			//print("\(username)")
			nameAlert.hidden = true
			
			let imageData = UIImagePNGRepresentation(userimage)!
			userweight = Float(userweight_main) + Float(userweight_fraction) * Float(0.1)
			let preImageData = userDefaults.objectForKey("headImage")
			if preImageData != nil {
				let preData = preImageData as! NSData
				// if image changes, upload current image onto server
				if imageData != preData {
					uploadHeadImage()
				}
			} else {
				uploadHeadImage()
			}
			
			submitUserInfo()
		}
	}

	@IBAction func imagePressed(sender: UIButton) {
		name.resignFirstResponder()
		showImagePicker()
	}
	/*
	@IBAction func blackViewPressed(sender: AnyObject) {
		tableView.hidden = true
		blackView.hidden = true
	}
*/
	@IBAction func blackViewTapped(sender: UITapGestureRecognizer) {
		hideImagePicker()
	}
	/*
	@IBAction func backgroundViewTapped(sender: UITapGestureRecognizer) {
		name.resignFirstResponder()
	}
	*/
	@IBAction func sexSelected(sender: AnyObject) {
		name.resignFirstResponder()
	}
	
	
	func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
		return 1
	}
	
	func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		if pickerView.tag == 0 {
			return ageRange.count
		} else if pickerView.tag == 1 {
			return heightRange.count
		} else if pickerView.tag == 2 {
			return weightRange.count
		} else if pickerView.tag == 3 {
			return weight_fractionRange.count
		} else if pickerView.tag == 4 {
			return bustRange.count
		} else if pickerView.tag == 5 {
			return waistRange.count
		} else if pickerView.tag == 6 {
			return hipRange.count
		}
		return 0
	}
	
	func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		//let item = String(ageRange[row])
		
		if pickerView.tag == 0 {
			return String(ageRange[row])
		} else if pickerView.tag == 1 {
			return String(heightRange[row])
		} else if pickerView.tag == 2 {
			return String(weightRange[row])
		} else if pickerView.tag == 3 {
			return String(weight_fractionRange[row])
		} else if pickerView.tag == 4 {
			return String(bustRange[row])
		} else if pickerView.tag == 5 {
			return String(waistRange[row])
		} else if pickerView.tag == 6 {
			return String(hipRange[row])
		}
		return nil
	}
	/*
	func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		name.resignFirstResponder()
		if pickerView.tag == 0 {
			selectedAge = ageRange[row]
		} else if pickerView.tag == 1 {
			selectedHeight = heightRange[row]
		} else if pickerView.tag == 2 {
			selectedWeight = weightRange[row]
		}
	}
	*/
	func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
		/*
		let pickerLabel = UILabel()
		var titleData: Int!
		if pickerView.tag == 0 {
			titleData = ageRange[row]
		} else if pickerView.tag == 1 {
			titleData = heightRange[row]
		} else if pickerView.tag == 2 {
			titleData = weightRange[row]
		}
		let myTitle = NSAttributedString
		pickerLabel.textAlignment = NSTextAlignment.Center
		return pickerLabel
*/
		var pickerLabel = view as! UILabel!
		if view == nil {
			pickerLabel = UILabel()
		}
		var titleData: String!
		if pickerView.tag == 0 {
			titleData = String(ageRange[row])
		} else if pickerView.tag == 1 {
			titleData = String(heightRange[row])
		} else if pickerView.tag == 2 {
			titleData = String(weightRange[row])
		} else if pickerView.tag == 3 {
			titleData = String(weight_fractionRange[row])
		} else if pickerView.tag == 4 {
			titleData = String(bustRange[row])
		} else if pickerView.tag == 5 {
			titleData = String(waistRange[row])
		} else if pickerView.tag == 6 {
			titleData = String(hipRange[row])
		}
		let myAttribute = [NSFontAttributeName: UIFont(name:"Helvetica", size:15)!]
		let myTitle = NSAttributedString(string:titleData, attributes: myAttribute)
		pickerLabel.attributedText = myTitle
		pickerLabel.textAlignment = NSTextAlignment.Center
		return pickerLabel
	}
	
	func pickerView(pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
		return 15
	}

	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell : UITableViewCell = tableView.dequeueReusableCellWithIdentifier("chooseCell", forIndexPath: indexPath) as UITableViewCell
		cell.textLabel?.text = self.groupList[indexPath.section][indexPath.row]
		cell.textLabel?.textAlignment = NSTextAlignment.Center
		//cell.accessoryType = UITableViewCellAccessoryType.d
		return cell
	}
	
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return self.groupList.count
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.groupList[section].count
	}
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		print("select row")
		if indexPath.section == 0 {
			if indexPath.row == 0 {
				// camera
				print("camera")
				hideImagePicker()
				imagePicker = UIImagePickerController()
				imagePicker.delegate = self
				imagePicker.sourceType = .Camera
				imagePicker.allowsEditing = true
				presentViewController(imagePicker, animated: true, completion: nil)
			} else if indexPath.row == 1 {
				// photo
				print("photo")
				hideImagePicker()
				imagePicker = UIImagePickerController()
				imagePicker.delegate = self
				imagePicker.sourceType = .PhotoLibrary
				imagePicker.modalTransitionStyle = UIModalTransitionStyle.CoverVertical
				imagePicker.allowsEditing = true
				presentViewController(imagePicker, animated: true, completion: nil)
			}
		} else if indexPath.section == 1 {
			if indexPath.row == 0 {
				// cancel
				print("cancel")
				hideImagePicker()
			}
		}
		tableView.deselectRowAtIndexPath(indexPath, animated: false)
	}
	
	func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 1
	}
	
	func setStatusBarBackgroundColor(color: UIColor, alpha: CGFloat) {
		guard let statusBar = UIApplication.sharedApplication().valueForKey("statusBarWindow")?.valueForKey("statusBar") as? UIView else {
			return
		}
		statusBar.backgroundColor = color
		statusBar.alpha = alpha
	}
	
	func setNavigationBarBackgroundColor(color: UIColor, alpha: CGFloat) {
		guard let statusBar = UIApplication.sharedApplication().valueForKey("NavigationBarWindow")?.valueForKey("statusBar") as? UIView else {
			return
		}
		//statusBar.backgroundColor = color
		statusBar.tintColor = color
		statusBar.backgroundColor = color
		statusBar.alpha = alpha
	}
	
	func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
		imagePicker.dismissViewControllerAnimated(true, completion: nil)
		let image = info[UIImagePickerControllerEditedImage] as? UIImage
		roundImage(image!, withParam: 2)
		
	}
	
	func showImagePicker() {
		blackView.hidden = false
		tableView.hidden = false
		//self.view.bringSubviewToFront(tableView)
		//setStatusBarBackgroundColor(UIColor.grayColor(),alpha: 0.5);
		self.navigationController?.navigationBar.alpha = 0.5

	}
	
	func hideImagePicker() {
		tableView.hidden = true
		blackView.hidden = true
		//setStatusBarBackgroundColor(UIColor.whiteColor(),alpha: 1);
		//self.navigationController?.navigationBar.barTintColor = UIColor.whiteColor()
		self.navigationController?.navigationBar.alpha = 1
	}
	
	func roundImage(image:UIImage, withParam inset:CGFloat) {
		UIGraphicsBeginImageContext(image.size)
		let context: CGContextRef = UIGraphicsGetCurrentContext()!
		CGContextSetLineWidth(context, 5)
		CGContextSetStrokeColorWithColor(context, UIColor.darkGrayColor().CGColor)
		
		let rect: CGRect = CGRectMake(inset, inset, CGFloat(image.size.width - inset * 2), CGFloat(image.size.height - inset * 2))
		CGContextAddEllipseInRect(context, rect)
		CGContextClip(context)
		image.drawInRect(rect)
		CGContextStrokePath(context)
		let newing = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		changeImage.setBackgroundImage(newing, forState: UIControlState.Normal)
	}
	
	func textFieldShouldReturn(textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return true
	}
	func submitUserInfo() {
		
		let urlPath = "\(url_prefix)updateInfo.php"
		//print("usrlPath: \(urlPath)")
		let url = NSURL(string: urlPath)
		let session = NSURLSession.sharedSession()
		let request = NSMutableURLRequest(URL: url!)
		request.HTTPMethod = "POST"
		let postBody = "id=\(userid)&name=\(username)&sex=\(usersex)&age=\(userage)&height=\(userheight)&weight_main=\(userweight_main)&weight_fraction=\(userweight_fraction)&weight=\(userweight)&bust=\(userbust)&waist=\(userwaist)&hip=\(userhip)"
		request.HTTPBody = postBody.dataUsingEncoding(NSUTF8StringEncoding)
		print("post body: \(postBody)")
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
							saveUserDefaultsInfo()
							self.navigationController?.popViewControllerAnimated(true)
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
	
	func uploadHeadImage(){
		//		var code = -1
		
		let boundary = "AaB03x"
		let imageData = UIImagePNGRepresentation(userimage)!
		
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
		body.appendData("Content-Disposition: form-data; name='userfile';filename='\(userid).png'".dataUsingEncoding(NSUTF8StringEncoding)!)
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
						userDefaults.setObject(imageData, forKey: "headImage")
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
