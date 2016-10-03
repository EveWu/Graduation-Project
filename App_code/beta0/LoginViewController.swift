//
//  LoginViewController.swift
//  beta0
//
//  Created by wu xiao yue on 4/9/16.
//  Copyright © 2016 eve. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController{
	
	@IBOutlet weak var name: UITextField!
	@IBOutlet weak var password: UITextField!
	@IBOutlet weak var enterButton: EnterButtonView!
	
	var alertController = UIAlertController(title: "登录出错", message: "用户名或密码错误", preferredStyle: UIAlertControllerStyle.Alert)
	let okAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.Default, handler: nil)
	
	override func viewDidLoad() {
		super.viewDidLoad()
		alertController.addAction(okAction)
		//setStatusBarBackgroundColor(purple_statusbar)
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
	}
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	@IBAction func enterPressed(sender: UIButton) {
		if name.text! == "" || password.text! == "" {
			alertController.message = "用户名或密码不能为空"
			self.presentViewController(self.alertController, animated: true, completion: nil)
		} else {
			verifyPassword()
		}
	}

	@IBAction func forgetPasswordPressed(sender: UIButton) {
		
	}
	
	@IBAction func signupPressed(sender: UIButton) {
		
	}
	
	func verifyPassword() {
		let urlPath = "\(url_prefix)login.php?name=\(name.text!)&password=\(password.text!)"
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
				dispatch_sync(dispatch_get_main_queue(), { () -> Void in
					// The Internet connection appears to be offline
					if error!.code == -1009 {
						self.alertController.message = "需要连接到网络才可以登录哟！"
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
					
					//print("status: \(status)")
					//print("data: \(userData)")
					dispatch_sync(dispatch_get_main_queue(), { () -> Void in
						if status == 0 {
							//let userData = jsonResult.objectForKey("data")
							let idresult = jsonResult.objectForKey("id")
							let id = idresult?.integerValue
							userid = id
							userDefaults.setInteger(userid, forKey: "id")
							
							getAllUserInfoServer()
							
							//saveUserDefaultsInfo()
							
							//self.setUserInfo(id!, data: userData!)
							self.performSegueWithIdentifier("showTabbar", sender: self)
						} else {
							self.alertController.message = "用户名或密码错误"
							self.presentViewController(self.alertController, animated: true, completion: nil)
						}
						
					})
					
				} catch {
					print("json error")
				}
			}
		}
		task.resume()
	}
	

}
