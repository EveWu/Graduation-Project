//
//  LaunchViewController.swift
//  beta0
//
//  Created by wu xiao yue on 4/8/16.
//  Copyright © 2016 eve. All rights reserved.
//

import UIKit

class LaunchViewController: UIViewController{
	

	@IBOutlet var backgroundView: UIView!
	
	@IBOutlet weak var left1: UIImageView!
	@IBOutlet weak var left2: UIImageView!
	@IBOutlet weak var left3: UIImageView!
	@IBOutlet weak var left4: UIImageView!
	
	@IBOutlet weak var right1: UIImageView!
	@IBOutlet weak var right2: UIImageView!
	@IBOutlet weak var right3: UIImageView!
	@IBOutlet weak var right4: UIImageView!
	
	@IBOutlet weak var platform: UIImageView!
	
	@IBOutlet weak var text: UILabel!
	
	let offset = 50
	
	override func viewDidLoad() {
		super.viewDidLoad()
		left1.alpha = 0
		left2.alpha = 0
		left3.alpha = 0
		left4.alpha = 0
		right1.alpha = 0
		right2.alpha = 0
		right3.alpha = 0
		right4.alpha = 0
		platform.alpha = 0
		text.alpha = 0
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		//UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: UIStatusBarAnimation.None)
		
	}
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		
		let interval = 0.15
		UIView.animateWithDuration(interval, animations: { () -> Void in
			self.platform.alpha = 1
		}, completion: { (Bool) -> Void in
			UIView.animateWithDuration(interval, animations: { () -> Void in
				self.left1.alpha = 1
				self.right1.alpha = 1
				}, completion: { (Bool) -> Void in
					UIView.animateWithDuration(interval, animations: { () -> Void in
						self.left1.alpha = 0
						}, completion: { (Bool) -> Void in
							UIView.animateWithDuration(interval, animations: { () -> Void in
								self.left2.alpha = 1
								}, completion: { (Bool) -> Void in
									UIView.animateWithDuration(interval, animations: { () -> Void in
										self.right1.alpha = 0
										}, completion: { (Bool) -> Void in
											UIView.animateWithDuration(interval, animations: { () -> Void in
												self.right2.alpha = 1
												}, completion: { (Bool) -> Void in
													UIView.animateWithDuration(interval, animations: { () -> Void in
														self.left2.alpha = 0
														}, completion: { (Bool) -> Void in
															UIView.animateWithDuration(interval, animations: { () -> Void in
																self.left3.alpha = 1
																}, completion: { (Bool) -> Void in
																	UIView.animateWithDuration(interval, animations: { () -> Void in
																		self.right2.alpha = 0
																		}, completion: { (Bool) -> Void in
																			UIView.animateWithDuration(interval, animations: { () -> Void in
																				self.right3.alpha = 1
																				}, completion: { (Bool) -> Void in
																					UIView.animateWithDuration(interval, animations: { () -> Void in
																						self.left3.alpha = 0
																						}, completion: { (Bool) -> Void in
																							UIView.animateWithDuration(interval, animations: { () -> Void in
																								self.left4.alpha = 1
																								}, completion: { (Bool) -> Void in
																									UIView.animateWithDuration(interval, animations: { () -> Void in
																										self.right3.alpha = 0
																										}, completion: { (Bool) -> Void in
																											UIView.animateWithDuration(interval, animations: { () -> Void in
																												self.right4.alpha = 1
																												}, completion: { (Bool) -> Void in
																													
																													UIView.animateWithDuration(interval, animations: { () -> Void in
																														self.backgroundView.backgroundColor = UIColor.whiteColor()
																														self.platform.image = UIImage(named: "platformPurple")
																														self.left4.image = UIImage(named: "leftFeet")
																														self.right4.image = UIImage(named: "rightFeet")
																														}, completion: { (Bool) -> Void in
																															let distance = self.backgroundView.bounds.height / 2 - CGFloat(self.offset) - self.platform.center.y
																															UIView.animateWithDuration(1, animations: { () -> Void in
																																self.left4.center.x -= 9.5
																																self.right4.center.x += 9.5
																																self.platform.center.y += distance
																																self.left4.center.y += distance
																																self.right4.center.y += distance
																																
																																self.platform.bounds = CGRect(x: 0, y: 0, width: 150, height: 150)
																																self.left4.bounds = CGRect(x: 0, y: 0, width: 48, height: 85.5)
																																self.right4.bounds = CGRect(x: 0, y: 0, width: 48, height: 85.5)
																																self.text.alpha = 1
																																}, completion: { (Bool) -> Void in
																																	
																																	NSThread.sleepForTimeInterval(1)
																																	
																																	userDefaults = NSUserDefaults.standardUserDefaults()
																																	userid = userDefaults.integerForKey("id")
																																	
																																	if userid == 0 {
																																		self.performSegueWithIdentifier("showLogin", sender: self)
																																	} else {
																																		// set user info
																																		self.verifyNetwork()
																																		self.performSegueWithIdentifier("showTabbar", sender: self)
																																	}
																															})
																													})
																											})
																									})
																							})
																					})
																			})
																	})
															})
													})
											})
									})
							})
					})
			})
		})

		/*
		UIView.animateWithDuration(1, delay: 0, options: UIViewAnimationOptions.TransitionCurlDown, animations: { () -> Void in
			self.platform.alpha = 1
			}, completion: { (Bool) -> Void in

			})
*/
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	override func prefersStatusBarHidden() -> Bool {
		return true
	}
	
	func getUserInfoLocal() {
		let image = userDefaults.objectForKey("headImage")
		if image != nil {
			userimageData = image as! NSData
			userimage = UIImage(data: userimageData)
		} else {
			userimage = UIImage(named: "head")
			userimageData = UIImagePNGRepresentation(userimage)
		}
		let name = userDefaults.objectForKey("name")
		if name != nil {
			username = name as! String
		} else {
			username = "访客"
		}
		usersex = userDefaults.integerForKey("sex")
		userage = userDefaults.integerForKey("age")
		userheight = userDefaults.integerForKey("height")
		userweight_main = userDefaults.integerForKey("weight_main")
		userweight_fraction = userDefaults.integerForKey("weight_fraction")
		userweight = userDefaults.floatForKey("weight")
		userbust = userDefaults.integerForKey("bust")
		userwaist = userDefaults.integerForKey("waist")
		userhip = userDefaults.integerForKey("hip")
		let test = userDefaults.objectForKey("testRecord")
		if test != nil {
			testRecord = test as! Array<Array<Array<String>>>
		} else {
			testRecord = Array<Array<Array<String>>>()
		}
		let training = userDefaults.objectForKey("trainingRecord")
	  if training != nil {
			trainingRecord = training as! Array<Array<String>>
		} else {
			trainingRecord = Array<Array<String>>()
		}
	}
	
	func verifyNetwork() {
		
		if userid != 0 {
			let urlPath = "\(url_prefix)login.php?name=test&password=test"
			//print("usrlPath: \(urlPath)")
			let url = NSURL(string: urlPath)
			let session = NSURLSession.sharedSession()
			let request = NSURLRequest(URL: url!)
			//print("start session")
			// get
			let task = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
				if error != nil {
					print(error!.localizedDescription)
					print("session error: \(error!.code)")
					// network is closed
					if error!.code == -1009 {
						print("get from local")
						self.getUserInfoLocal()
					}
				} else {
					print("get from server")
					let code = getAllUserInfoServer()
//					if code != 0 {
//						print("get from local")
//						self.getUserInfoLocal()
//					}
					
					//saveUserDefaultsInfo()
				}
			}
			task.resume()
		}
	}
	
}
