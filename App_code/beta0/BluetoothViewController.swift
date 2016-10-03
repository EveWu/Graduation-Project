//
//  BluetoothViewController.swift
//  beta0
//
//  Created by wu xiao yue on 3/25/16.
//  Copyright © 2016 eve. All rights reserved.
//

import UIKit
import CoreBluetooth

class BluetoothViewController: UIViewController, CBCentralManagerDelegate, CBPeripheralDelegate {
	
	/* bluetooth */
	private var centralManager: CBCentralManager?
	private var discoveredPeripheral: CBPeripheral?
	private var data = NSMutableData()
	
	@IBOutlet weak var tutorText: UILabel!
	@IBOutlet weak var startButton: UIButton!
	

	
	let alertController = UIAlertController(title: "设备蓝牙未开启", message: "请前往设置开启蓝牙", preferredStyle: UIAlertControllerStyle.Alert)
	let okAction = UIAlertAction(title: "好的", style: UIAlertActionStyle.Default, handler: nil)
	func initView() {
		
		
		
		//tutorText.sizeToFit()
		tutorText.lineBreakMode = NSLineBreakMode.ByWordWrapping
		tutorText.numberOfLines = 0
		if self.title == "connectTest" {
			tutorText.text = "请保持目视前方，双手放在身体两侧，尽可能维持身体的稳定。姿势若完成失败，则测试会停止。"
		} else if self.title == "connectTraining" {
			tutorText.text = "保持双脚固定在测试仪上，通过改变身体姿态控制身体的重心。当重心在指定时间内到达指定点时，视为成功。累计失败三次则训练结束。"
		}
		
		tutorText.sizeToFit()
		tutorText.font = UIFont.systemFontOfSize(13)
		tutorText.textColor = UIColor.blackColor()
		let string: NSString = tutorText.text!
		let options: NSStringDrawingOptions = .UsesLineFragmentOrigin
		let boundingRect = string.boundingRectWithSize(CGSizeMake(320, 0), options: options, attributes: [NSFontAttributeName:tutorText.font], context: nil)
		tutorText.frame = CGRectMake(0, 0, boundingRect.width, boundingRect.height)
		
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		initView()
		//setStatusBarBackgroundColor(UIColor.whiteColor())
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(false)
		centralManager = CBCentralManager(delegate: self, queue: nil)
		//setStatusBarBackgroundColor(UIColor.whiteColor())
		self.navigationController?.setNavigationBarHidden(false, animated: animated)
		alertController.addAction(okAction)
		
	}
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	

	
	@IBAction func startPressed(sender: UIButton) {
		
		if centralManager?.state == .PoweredOn {
			if self.title == "ConnectTest" {
				performSegueWithIdentifier("showTest", sender: self)
			} else if self.title == "ConnectTraining" {
				performSegueWithIdentifier("showTraining", sender: self)
			}
			
		}
		else {
			self.presentViewController(alertController, animated: true, completion: nil)
		}
	}
	
	/* bluetooth part */
	func centralManagerDidUpdateState(central:CBCentralManager) {
		switch(central.state) {
		case .Unknown:
			print("Unknown")
			break
		case .Resetting:
			print("Resetting")
			break
		case .Unsupported:
			print("Unsupported")
			break
		case .Unauthorized:
			print("Unauthorized")
			break
		case .PoweredOff:
			print("PoweredOff")
			
			/*
			let alerView: UIAlertView = UIAlertView.init(title: "设备蓝牙未开启，请前往设置开启", message: nil, delegate: self, cancelButtonTitle: "知道了")
			alerView.show()
*/
			/*
			let alertController = UIAlertController(title: "设备蓝牙未开启", message: "请前往设置开启蓝牙", preferredStyle: UIAlertControllerStyle.Alert)
			let okAction = UIAlertAction(title: "知道了", style: UIAlertActionStyle.Default, handler: nil)
			alertController.addAction(okAction)
*/
			break
		case .PoweredOn:
			print("PoweredOn")
			
			break
		}
	}

}
