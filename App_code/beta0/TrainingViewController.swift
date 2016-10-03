//
//  TrainingViewController.swift
//  beta0
//
//  Created by wu xiao yue on 4/4/16.
//  Copyright © 2016 eve. All rights reserved.
//

import UIKit
import CoreBluetooth

class TrainingViewController: UIViewController, CBCentralManagerDelegate, CBPeripheralDelegate {


	@IBOutlet weak var successText: UILabel!
	@IBOutlet weak var timePassedText: UILabel!
	@IBOutlet weak var failText: UILabel!
	@IBOutlet weak var timeLeftText: UILabel!
	@IBOutlet weak var tutorText: UILabel!

	
	@IBOutlet weak var bottomView: UIView!
	@IBOutlet weak var position: UIImageView!
	@IBOutlet weak var target: UIImageView!
	
	/* bluetooth */
	private var centralManager: CBCentralManager?
	private var discoveredPeripheral: CBPeripheral?
	private var data = NSMutableData()
	
	/* cop data */
	private var total_data = String()
	private var currentStep: Int!
	private var initial = Array<Array<Float>>()
	private var initial_data = Array<Float>()
	private var nearby: CGFloat!
	private var targetChanging: Bool!
	private var x_max: CGFloat!
	private var x_min: CGFloat!
	private var y_max: CGFloat!
	private var y_min: CGFloat!
	private let targetBoundWidth = 120		// 150mm
	
	/* timer */
	private var timer: NSTimer?
	private var timeLeft: Int!
	private var timePassed: Int!
	
	/* count */
	private var successNumber: Int!
	private var failNumber: Int!
	private var timeUsedLeast: Int!
	private var timeUsedMost: Int!
	
	/* alert window */
	let alertController = UIAlertController(title: "用户未登录", message: "请前往个人信息登录", preferredStyle: UIAlertControllerStyle.Alert)
	let okAction = UIAlertAction(title: "好的", style: UIAlertActionStyle.Default, handler: nil)
	
	func initView() {
		x_max = -225
		x_min = 225
		y_max = -225
		y_min = 225
		
		failNumber = 0
		successNumber = 0
		timeUsedLeast = 30
		timeUsedMost = 0
		currentStep = -1
		timeLeft = 5
		timePassed = 0
		tutorText.text = "测试仪校正，请勿站上测试仪"
		successText.text = "0"
		failText.text = "0"
		timeLeftText.text = String(timeLeft) + "秒"
		timePassedText.text = String(timePassed) + "秒"
		target.frame = CGRectMake(0.0, 0.0, 20, 20)
		target.alpha = 0
		position.frame = CGRectMake(0.0, 0.0, 20, 20)
		position.alpha = 0
		targetChanging = false
		
		
		
		timer?.invalidate()
		if (discoveredPeripheral != nil) {
			centralManager?.cancelPeripheralConnection(discoveredPeripheral!)
		}
		centralManager?.stopScan()
	}
	
	func setupGraphic() {
		//	print("bottom center 1: (\(bottomView.center.x), \(bottomView.center.y))")
		target.center = CGPoint(x: bottomView.bounds.width / 2, y: bottomView.bounds.height / 2 - 20)
		//print("bottom center 2: (\(bottomView.center.x), \(bottomView.center.y))")
		position.center = CGPoint(x: bottomView.bounds.width / 2, y: bottomView.bounds.height / 2 + 20)
		nearby = target.bounds.width / 2 + position.bounds.width / 2
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib
		initView()
		//print("bottom center after initView: (\(bottomView.center.x), \(bottomView.center.y))")
		timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("updateTime"), userInfo: nil, repeats: true)
		centralManager = CBCentralManager(delegate: self, queue: nil)
		//setStatusBarBackgroundColor(UIColor.groupTableViewBackgroundColor())
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		self.navigationController?.setNavigationBarHidden(true, animated: animated)
	}
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		setupGraphic()
		
		//print("bottom center in viewDidAppear: (\(bottomView.center.x), \(bottomView.center.y))")
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	override func	viewDidDisappear(animated: Bool) {
		super.viewDidDisappear(true)
		print("viewDidDisappear")
		initView()
	}
	
	@IBAction func stopPressed(sender: UIButton) {
		//UIView.animateWithDuration(1, animations: {self.position.center.y -= 20})
		//UIView.animateWithDuration(1, animations: {self.position.frame = CGRectMake(100, 100, 40, 40)})
		/*
		print("bottom center 3: (\(bottomView.center.x), \(bottomView.center.y))")
		let temp = CGPoint(x: bottomView.bounds.width / 2, y: bottomView.bounds.height / 2 - 20)
		movetoPosition(temp)
		print("cop position: (\(position.center.x), \(position.center.y))")
		*/
		print("x min: \(x_min), x max: \(x_max)")
		print("y min: \(y_min), y max: \(y_max)")
		performSegueWithIdentifier("showTrainingResult", sender: self)
	}
	
	func updateTime() {
		if targetChanging == true {
			// do not update time
		} else {
			timeLeft = timeLeft - 1
			if currentStep == 1 {
				timePassed = timePassed + 1
			}
			if timeLeft == 0 {
				if currentStep == -1 {
					initial_data = getInital(initial)
					tutorText.text = "请站上测试仪，训练将在10秒后开始"
					currentStep = 0
					timeLeft = 10
				} else if currentStep == 0 {
					currentStep = 1
					timeLeft = 30
					tutorText.text = "训练进行中"
					showTarget()
					/*
					UIView.animateWithDuration(0.1, animations: { () -> Void in
						self.target.alpha = 1
						self.position.alpha = 1
						}, completion: { (Bool) -> Void in
							self.targetChanging = false
					})
					print("target position: (\(target.center.x), \(target.center.y))")
					print("old cop position: (\(position.center.x), \(position.center.y))")
*/
				} else if currentStep == 1{
					targetChanging = true
					timeUsedMost = 30
					if failNumber == 2 {
						failNumber = failNumber + 1
						// target turn red and then jump to result
						UIView.animateWithDuration(0.1, animations: { () -> Void in
							self.target.image = UIImage(named: "fail")
							}, completion: { (Bool) -> Void in
								//self.targetChanging = false
								self.performSegueWithIdentifier("showTrainingResult", sender: self)
						})
						
					} else {
						failNumber = failNumber + 1
						timeLeft = 30
						failText.text = String(failNumber)
						// target turn red, then disappear and then new target appear
						UIView.animateWithDuration(0.1, animations: { () -> Void in
							self.target.image = UIImage(named: "fail")
							}, completion: { (Bool) -> Void in
								self.hideTarget()
						})
					}
				}
			}
			timeLeftText.text = String(timeLeft) + "秒"
			let minute = timePassed / 60
			if minute == 0 {
				timePassedText.text = String(timePassed) + "秒"
			} else {
				let second = timePassed % 60
				timePassedText.text = String(minute) + "分" + String(second) + "秒"
			}
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
			break
		case .PoweredOn:
			print("PoweredOn")
			scan()
			break
		}
	}
	
	func scan() {
		centralManager?.scanForPeripheralsWithServices(nil, options: nil)
		print("Scanning started")
	}
	
	func centralManager(central: CBCentralManager, didDiscoverPeripheral peripheral: CBPeripheral, advertisementData: [String : AnyObject], RSSI: NSNumber) {
		print("Discovered \(peripheral.name) at \(RSSI)")
		
		if discoveredPeripheral != peripheral {
			discoveredPeripheral = peripheral
			print("Connecting to peripheral \(peripheral)")
			centralManager?.connectPeripheral(peripheral, options: nil)
		}
	}
	
	func centralManager(central: CBCentralManager, didFailToConnectPeripheral peripheral: CBPeripheral, error: NSError?) {
		print("Failed to connect to \(peripheral).(\(error!.localizedDescription))")
		cleanup()
	}
	
	private func cleanup() {
		if discoveredPeripheral?.state != CBPeripheralState.Connected {
			return
		}
		
		if let services = discoveredPeripheral?.services as [CBService]? {
			for service in services {
				if let characteristics = service.characteristics as [CBCharacteristic]? {
					for characteristic in characteristics {
						if characteristic.UUID.isEqual(transferCharacteristicUUID) && characteristic.isNotifying {
							discoveredPeripheral?.setNotifyValue(false, forCharacteristic: characteristic)
							return
						}
					}
				}
			}
		}
		centralManager?.cancelPeripheralConnection(discoveredPeripheral!)
	}
	
	func centralManager(central: CBCentralManager, didConnectPeripheral peripheral: CBPeripheral) {
		print("Peripheral Connected")
		
		centralManager?.stopScan()
		print("Scanning stopped")
		
		data.length = 0
		peripheral.delegate = self
		peripheral.discoverServices(nil)
	}
	
	func peripheral(peripheral: CBPeripheral, didDiscoverServices error: NSError?) {
		if let error = error {
			print("Error discovering services: \(error.localizedDescription)")
			cleanup()
			return
		}
		
		for service in peripheral.services as [CBService]! {
			peripheral.discoverCharacteristics(nil, forService: service)
		}
	}
	
	func peripheral(peripheral: CBPeripheral, didDiscoverCharacteristicsForService service: CBService, error: NSError?) {
		if let error = error {
			print("Error discovering services: \(error.localizedDescription)")
			cleanup()
			return
		}
		
		for characteristic in service.characteristics as [CBCharacteristic]! {
			if characteristic.UUID.isEqual(transferCharacteristicUUID) {
				peripheral.setNotifyValue(true, forCharacteristic: characteristic)
			}
		}
	}
	
	func peripheral(peripheral: CBPeripheral, didUpdateValueForCharacteristic characteristic: CBCharacteristic, error: NSError?) {
		if let error = error {
			print("Error discovering services: \(error.localizedDescription)")
			return
		}
		let stringFromData = String(data: characteristic.value!, encoding: NSUTF8StringEncoding)
		if stringFromData != nil {
			data.appendData(characteristic.value!)
			//print("Received: \(stringFromData)")
			getTotalData(stringFromData!)
		}
	}
	
	func peripheral(peripheral: CBPeripheral, didUpdateNotificationStateForCharacteristic characteristic: CBCharacteristic, error: NSError?) {
		if let error = error {
			print("Error changing notification state \(error.localizedDescription)")
			return
		}
		
		if !characteristic.UUID.isEqual(transferCharacteristicUUID) {
			return
		}
		
		if (characteristic.isNotifying) {
			print("Notification began on \(characteristic)")
		} else {
			print("Notification stopped on (\(characteristic)) Disconnecting")
			centralManager?.cancelPeripheralConnection(peripheral)
		}
	}
	
	func centralManager(central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: NSError?) {
		print("Peripheral Disconnected")
		discoveredPeripheral = nil
		
		//scan()
	}
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "showTrainingResult" {
			let secondViewController: TrainingResultViewController = segue.destinationViewController as! TrainingResultViewController
			secondViewController.successNumber = successNumber
			secondViewController.failNumber = failNumber
			secondViewController.timePassed = timePassed
			secondViewController.timeUsedLeast = timeUsedLeast
			secondViewController.timeUsedMost = timeUsedMost
			secondViewController.training = true
		}
	}
	
	func getTotalData(stringFromData: String) {
		let range = stringFromData.rangeOfCharacterFromSet(NSCharacterSet(charactersInString: "\n"))
		// there has a "\n"
		if range != nil{
			var second = String()
			if stringFromData.hasPrefix("\n") || stringFromData.hasPrefix("\r\n") {
				second = stringFromData.stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: "\r\n"))
			} else if stringFromData.hasSuffix("\n") {
				total_data = total_data + stringFromData
			} else {
				let seperate = stringFromData.componentsSeparatedByString("\r\n")
				total_data = total_data + seperate[0]
				second = seperate[1]
			}
			//print("total: \(total_data)")
			total_data = total_data.stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: "\r\n"))
			let dataArray = total_data.characters.split(",").map(String.init)
			if dataArray.count == 16 {
				var transformed_data = transform(dataArray)
				if currentStep == -1 {
					if timeLeft >= 2 && timeLeft <= 4 {
						initial.append(transformed_data)
					}
				} else if currentStep == 1{
					//print("transformed data before: \(transformed_data)")
					for var count = 0; count < transformed_data.count; count++ {
						transformed_data[count] = transformed_data[count] - initial_data[count]
					}
					print("transformed data after: \(transformed_data)")
					
					let userDefaultes = NSUserDefaults.standardUserDefaults()
					let username = userDefaultes.objectForKey("name")
					if username == nil {
						self.presentViewController(alertController, animated: true, completion: nil)
					} else {
						let userweight = userDefaultes.integerForKey("weight")
						let userweight_fraction = userDefaultes.integerForKey("weight_fraction")
						let weight = Float(userweight) + Float(userweight_fraction) * Float(0.1)
						var cop = CGPoint(x: 0.0, y: 0.0)
						cop = getCoP(transformed_data[14], Pb: transformed_data[1], Pc: transformed_data[0], Pd: transformed_data[15], m: weight)
						print("cop: (\(cop.x), \(cop.y))")
						if cop.x < x_min {
							x_min = cop.x
						}
						if cop.x > x_max {
							x_max = cop.x
						}
						if cop.y < y_min {
							y_min = cop.y
						}
						if cop.y > y_max {
							y_max = cop.y
						}
						movetoPosition(cop)
					}
				}
			} else {		// data size not equal to 16
				print("Invalid data")
				
			}
			total_data = second
		} else {		// string contains no "\n"
			total_data = total_data + stringFromData
		}
	}
	func movetoPosition(cop: CGPoint) {
		let new_x = bottomView.bounds.width / 2 + cop.x * (bottomView.bounds.width / CGFloat(targetBoundWidth * 2))
		let new_y = bottomView.bounds.height / 2 - cop.y * (bottomView.bounds.height / CGFloat(targetBoundWidth * 2))
		let new_position = CGPoint(x: new_x, y: new_y)
		//let new_position = cop
		if targetChanging == true {
			print("target changing ...")
			UIView.animateWithDuration(0.01, animations: { () -> Void in
				self.position.center = new_position
				self.position.alpha = 1
				}, completion: nil)
		} else {
			
			let distance = sqrt(pow(new_position.x - target.center.x, CGFloat(2)) + pow(new_position.y - target.center.y, CGFloat(2)))
			print("distance: \(distance)")
			if distance <= nearby {
				targetChanging = true
				let timeUsed = 30 - timeLeft
				if timeUsed < timeUsedLeast {
					timeUsedLeast = timeUsed
				}
				if timeUsed > timeUsedMost {
					timeUsedMost = timeUsed
				}
			}
			UIView.animateWithDuration(0.01, animations: { () -> Void in
				self.position.center = new_position
				self.position.alpha = 1
				}, completion: { (Bool) -> Void in
					// success
					if distance <= self.nearby {
						print("success")
						self.successNumber = self.successNumber + 1
						self.successText.text = String(self.successNumber)
						self.timeLeft = 30
						self.timeLeftText.text = String(self.timeLeft) + "秒"
						// turn target color to green
						UIView.animateWithDuration(1, animations: { () -> Void in
							self.target.image = UIImage(named: "success")
							}, completion: { (Bool) -> Void in
								self.hideTarget()
						})
					}
			})
		}
	}
	
	// old target disappear
	func hideTarget() {
		UIView.animateWithDuration(1, animations: { () -> Void in
			self.target.alpha = 0
			}, completion: { (Bool) -> Void in
				self.showTarget()
		})
	}
	
	func showTarget() {
		targetChanging = true
		target.center = newTargetPosition()
		target.image = UIImage(named: "target")
		UIView.animateWithDuration(1, animations: { () -> Void in
			self.target.alpha = 1
			}, completion: { (Bool) -> Void in
				self.targetChanging = false
		})
	}
	
	func newTargetPosition() -> CGPoint {
		var result = CGPoint()
		srand48(Int(time(nil)))
		result.x = CGFloat(drand48()) * bottomView.bounds.width
		srand48(Int(time(nil)))
		result.y = CGFloat(drand48()) * bottomView.bounds.height
		return result
	}
	
}
