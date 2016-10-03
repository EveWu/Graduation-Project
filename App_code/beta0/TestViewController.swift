//
//  TestViewController.swift
//  beta0
//
//  Created by wu xiao yue on 3/21/16.
//  Copyright © 2016 eve. All rights reserved.
//

import UIKit
import CoreBluetooth

class TestViewController: UIViewController, CBCentralManagerDelegate, CBPeripheralDelegate {
	
	@IBOutlet weak var progressBar: UIProgressView!
	@IBOutlet weak var stepText: UILabel!
	@IBOutlet weak var tutorText: UILabel!
	@IBOutlet weak var timeText: UILabel!
	@IBOutlet weak var stopButton: UIButton!
	//@IBOutlet weak var startButton: UIButton!
	
	//private var startButtonPressed: Bool?
	private var currentStep: Int?
	private var progress: Float?
	private var total: Float?
	
	/* bluetooth */
	private var centralManager: CBCentralManager?
	private var discoveredPeripheral: CBPeripheral?
	private var data = NSMutableData()
	
	/* cop data */
	private var total_data = String()
	private var copArray = Array<Array<CGPoint>>(count: 4, repeatedValue: Array<CGPoint>())
	private var initial = Array<Array<Float>>()
	private var initial_data = Array<Float>()
	
	/* timer */
	private var timer: NSTimer?
	private var timeLeft: Int?
	
	/* alert window */
	let alertController = UIAlertController(title: "用户未登录", message: "请前往个人信息登录", preferredStyle: UIAlertControllerStyle.Alert)
	let okAction = UIAlertAction(title: "好的", style: UIAlertActionStyle.Default, handler: nil)
	
	func initItem() {
		progressBar.progress = 0
		stepText.text = "0/4"
		currentStep = -1
		//tutorText.text = "先后需要进行4个姿势的测试，每个姿势之间有10s的调整姿势的时间。请保持目视前方，双手放在身体两侧，尽可能维持身体的稳定。姿势若完成失败，则测试会停止。"
		
		tutorText.text = "测试仪校正：请将测试仪空载平放在地上，此时不要站上测试仪。"
		tutorText.sizeToFit()
		timeText.text = "5s"
		timeLeft = 5
		progress = 0
		total = 135
		//startButton.setTitle("停止", forState: UIControlState.Normal)
		//startButtonPressed = true
		//startButton.setBackgroundImage(UIImage(named: "stopButton"), forState: UIControlState.Normal)
		timer?.invalidate()
		//centralManager?.stopScan()
		if (discoveredPeripheral != nil) {
			centralManager?.cancelPeripheralConnection(discoveredPeripheral!)
		}
		centralManager?.stopScan()
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		
		print("viewDidload")
		initItem()
		print("start time count")
		timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("updateTime"), userInfo: nil, repeats: true)
		centralManager = CBCentralManager(delegate: self, queue: nil)
		
		//setStatusBarBackgroundColor(UIColor.groupTableViewBackgroundColor())
	}
	

	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(false)
		print("viewWillAppear")
		self.navigationController?.setNavigationBarHidden(true, animated: animated)
		
	}
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(false)
		print("viewDidAppear")
	}
	
	override func viewWillDisappear(animated: Bool) {
		super.viewWillDisappear(animated)
		print("viewDidDisappear")
		//timer?.invalidate()
		//initItem()
		//print("Stopping scan")
		//centralManager?.stopScan()
	}
	
	override func	viewDidDisappear(animated: Bool) {
		super.viewDidDisappear(true)
		print("viewDidDisappear")
		initItem()
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	@IBAction func stopPressed(sender: UIButton) {
		centralManager?.stopScan()
		self.navigationController?.popViewControllerAnimated(true)
	}
	/*
	@IBAction func resultPressed(sender: UIButton) {
		timer?.invalidate()
		centralManager?.stopScan()
		self.performSegueWithIdentifier("showTestResult", sender: self)
	}
	*/
	
	/* timer selector */
	func updateTime() {
		timeLeft = timeLeft! - 1
		progress = progress! + 1
		progressBar.setProgress(progress! / total!, animated: true)
		if timeLeft == 0 {
			/* break time up */
			if currentStep == -1 {
				initial_data = getInital(initial)
				tutorText.text = "双腿睁眼站立：测试时间为30秒。现在你有10s的调整时间，请站上测试仪。"
				stepText.text = "1/4"
				timeLeft = 10
			} else {
				if currentStep! % 2 == 0 {
					if currentStep == 0 {
						tutorText.text = "双腿睁眼站立：测试时间为30秒。调整时间结束，测试开始。"
						
						timeLeft = 30
					} else if currentStep == 2 {
						tutorText.text = "双腿闭眼站立：测试时间为30秒。调整时间结束，测试开始。"
						
						timeLeft = 30
					} else if currentStep == 4 {
						tutorText.text = "优势腿睁眼站立：测试时间为15秒。调整时间结束，测试开始。"
						
						timeLeft = 15
					} else if currentStep == 6 {
						tutorText.text = "优势腿闭眼站立：测试时间为15秒。调整时间结束，测试开始。"
						
						timeLeft = 15
					}
					
				} else {
					if currentStep == 1 {
						tutorText.text = "双腿闭眼站立：测试时间为30秒。现在你有10s的调整时间。"
						stepText.text = "2/4"
					} else if currentStep == 3 {
						tutorText.text = "优势腿睁眼站立：测试时间为15秒。现在你有10s的调整时间。"
						stepText.text = "3/4"
					} else if currentStep == 5 {
						tutorText.text = "优势腿闭眼站立：测试时间为15秒。现在你有10s的调整时间。"
						stepText.text = "4/4"
					} else if currentStep == 7 {
						timer?.invalidate()
						centralManager?.stopScan()
						self.performSegueWithIdentifier("showTestResult", sender: self)
					}
					timeLeft = 10
				}
			}
			currentStep = currentStep! + 1
		}
		print("timeLeft: \(timeLeft!)")
		timeText.text = String(timeLeft!) + "s"
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
		if segue.identifier == "showTestResult" {
			let secondViewController: TestResultViewController = segue.destinationViewController as! TestResultViewController
			secondViewController.copArray = copArray
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
				} else if currentStep! % 2 == 1 {
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
						let index = currentStep! / 2
						copArray[index].append(cop)
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
	
}













































