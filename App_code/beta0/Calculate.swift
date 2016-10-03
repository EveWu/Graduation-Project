//
//  Calculate.swift
//  beta0
//
//  Created by wu xiao yue on 3/27/16.
//  Copyright © 2016 eve. All rights reserved.
//

import UIKit

let IPAddress = "172.16.5.75"
//let IPAddress = "192.168.1.108"
let url_prefix = "http://\(IPAddress)/~wuxiaoyue/beta0/"

let half_platform_width: Float = 222.5    //mm
let half_platform_height: Float = 222.5   //mm
let controll: [Float] = [220.3,142,0,0,0,0,0,0,0,0,0,0,0,0,150.3,148.3]
let testIndexNumber = 6

var Pa_before = 0.0
var Pb_before = 0.0
var Pc_before = 0.0
var Pd_before = 0.0

var ageRange: Array<Int> = []
var heightRange: Array<Int> = []
var weightRange: Array<Int> = []
var weight_fractionRange: Array<Int> = []
var bustRange: Array<Int> = []
var waistRange: Array<Int> = []
var hipRange: Array<Int> = []

var userDefaults: NSUserDefaults!
var userid: Int!
var username: String!
var userimage: UIImage!
var userimageData: NSData!
var usersex: Int!
var userage: Int!
var userheight: Int!
var userweight_main: Int!
var userweight_fraction: Int!
var userweight: Float!
var userbust: Int!
var userwaist: Int!
var userhip: Int!
var testRecord = Array<Array<Array<String>>>()
var trainingRecord = Array<Array<String>>()


func transform(data: Array<String>) -> Array<Float> {
	var result = Array<Float>(count: data.count, repeatedValue: 0.0)
	// transform function to be done
	for var count = 0; count < data.count; count++ {
		if count == 0 || count == 1 || count == 14 || count == 15 {
			result[count] = Float(data[count])! * controll[count] / (10 * (1023 - Float(data[count])!))
		} else {
			result[count] = Float(data[count])!
		}
	}
	return result
}

func getInital(data: Array<Array<Float>>) -> Array<Float> {
	var result = Array<Float>(count: 16, repeatedValue: 0.0)
	for var count = 0; count < data.count; count++ {
		for var second_count = 0; second_count < data[count].count; second_count++ {
			result[second_count] = result[second_count] + data[count][second_count]
		}
	}
	for var count = 0; count < result.count; count++ {
		result[count] = result[count] / Float(data.count)
	}
	return result
}

func getCoP(Pa: Float, Pb: Float,Pc: Float,Pd: Float,m: Float) -> CGPoint{
	var cop = CGPoint(x: 0.0, y: 0.0)
	/*
	let total = Pa + Pb + Pc + Pd
	let a = Pa * m / total
	let b = Pb * m / total
	let c = Pc * m / total
	let d = Pd * m / total
*/
	cop.x = CGFloat((Pa + Pd - Pb - Pc) * half_platform_width / m)
	cop.y = CGFloat((Pa + Pb - Pc - Pd) * half_platform_height / m)
	return cop
}

func getLng(copArray: Array<CGPoint>) -> Float{
	var lng: Float = 0.0
	for var count = 1; count < copArray.count; count++ {
		let distance = Float(sqrt(pow(copArray[count].x - copArray[count-1].x, 2) + pow(copArray[count].y - copArray[count-1].y, 2)))
		lng = lng + distance
	}
	return lng
}

func getLngx(copArray: Array<CGPoint>) -> Float{
	var lngx: Float = 0.0
	for var count = 1; count < copArray.count; count++ {
		let distance = Float(abs(copArray[count].x - copArray[count-1].x))
		lngx = lngx + distance
	}
	return lngx
}

func getLngy(copArray: Array<CGPoint>) -> Float{
	var lngy: Float = 0.0
	for var count = 1; count < copArray.count; count++ {
		let distance = Float(abs(copArray[count].y - copArray[count-1].y))
		lngy = lngy + distance
	}
	return lngy
}

func getLng_a(lng: Float, area: Float) -> Float {
	var lng_a: Float = 0.0
	lng_a = lng / area
	return lng_a
}

func getDeg(copArray: Array<CGPoint>, H: Float) -> Float {
	var Deg: Float = 0.0
	for var count = 1; count < copArray.count; count++ {
		let lng = Float(sqrt(pow(copArray[count].x - copArray[count-1].x, 2) + pow(copArray[count].y - copArray[count-1].y, 2)))
		let degree = asin(lng / H)
		Deg = Deg + degree
	}
	Deg = Deg / Float(copArray.count - 1)
	return Deg
}

func getMv(lng: Float, t: Float) -> Float {
	var mv: Float = 0.0
	mv = lng / t
	return mv
}

func getH(weight: Float, height: Float, bust: Float, waist: Float, hip: Float, sex: Int) -> Float {
	var H: Float = 0.0
	// 0 -> man, 1 -> woman
	if sex == 0 {
		H = height - (-160.3280 - 2.8349 * weight + 0.6439 * height + 0.1150 * bust + 0.0519 * waist)
	} else {
		H = height - (-205.392 - 1.5518 * weight + 0.6422 * height + 0.0894 * bust + 0.1640 * waist - 0.0656 * hip)
	}
	return H
}

func getEng(copArray: Array<CGPoint>, H: Float, weight: Float) -> Float {
	var distance: Float = 0.0
	var eng: Float = 0.0
	let g: Float = 9.81
	for var count = 2; count < copArray.count; count++ {
		let lng1 = Float(sqrt(pow(copArray[count].x - copArray[count-1].x, 2) + pow(copArray[count].y - copArray[count-1].y, 2)))
		let degree1 = asin(lng1 / H)
		
		let lng2 = Float(sqrt(pow(copArray[count-1].x - copArray[count-2].x, 2) + pow(copArray[count-1].y - copArray[count-2].y, 2)))
		let degree2 = asin(lng2 / H)
	  distance = distance + abs(H * cos(degree1) - H * cos(degree2))
	}
	eng = weight * g * distance / 1000
	return eng
}

func getPolygon(copArray: Array<CGPoint>) -> Array<CGPoint> {
	// find the point which is at the left-bottom
	var min: Int = 0
	var sortedCop = Array<CGPoint>(copArray)
	for var count = 1; count < copArray.count; count++ {
		if copArray[count].y < copArray[min].y {
			min = count
		} else if copArray[count].y == copArray[min].y {
			if copArray[count].x < copArray[min].x {
				min = count
			}
		}
	}
	// calculate cos value
	let firstPoint = CGPoint(x: copArray[min].x, y: copArray[min].y)
	sortedCop[0] = firstPoint
	sortedCop[min] = copArray[0]
	var cosVaule = Array<Float>(count: copArray.count, repeatedValue: 0.0)
	for var count = 0; count < copArray.count; count++ {
		if count == min {
			cosVaule[count] = 1
		} else {
			let temp = Float((copArray[count].x - firstPoint.x) / sqrt(pow(copArray[count].x - firstPoint.x, 2) + pow(copArray[count].y - firstPoint.y, 2)))
			cosVaule[count] = temp
		}
	}
	cosVaule[min] = cosVaule[0]
	cosVaule[0] = 1
	// sort cop points according to the cos value
	for var count = 1; count < sortedCop.count - 1; count++ {
		var max = count
		for var second = count + 1; second < sortedCop.count; second++ {
			if cosVaule[second] > cosVaule[max] {
				max = second
			} else if cosVaule[second] == cosVaule[max] {
				let distance_max = sqrt(pow(sortedCop[max].x - firstPoint.x, 2) + pow(sortedCop[max].y - firstPoint.y, 2))
				let distance_second = sqrt(pow(sortedCop[second].x - firstPoint.x, 2) + pow(sortedCop[second].y - firstPoint.y, 2))
				if distance_second < distance_max {
					max = second
				}
			}
		}
		let temp = sortedCop[max]
		sortedCop[max] = sortedCop[count]
		sortedCop[count] = temp
		
		let temp_value = cosVaule[max]
		cosVaule[max] = cosVaule[count]
		cosVaule[count] = temp_value
	}
	// find the convex polygon
	var convex_polygon = Array<CGPoint>()
	convex_polygon.append(sortedCop[0])
	var count = 1
	var total = sortedCop.count
	while count < total - 1  && count >= 0{
		var position: Float = 0.0
		if count == total - 2 {
			let a = Float((sortedCop[0].x - sortedCop[count].x) * (sortedCop[count+1].y - sortedCop[count].y))
			let b = Float((sortedCop[0].y - sortedCop[count].y) * (sortedCop[count+1].x - sortedCop[count].x))
			position = a - b
		} else {
			let a = Float((sortedCop[count+2].x - sortedCop[count].x) * (sortedCop[count+1].y - sortedCop[count].y))
			let b = Float((sortedCop[count+2].y - sortedCop[count].y) * (sortedCop[count+1].x - sortedCop[count].x))
			position = a - b
		}
		if position < 0 {   //on the right
			count++
		} else {						//on the left or on the line
			sortedCop.removeAtIndex(count+1)
			total--
			count--
		}
	}
	return sortedCop
}

func getArea(sortedCop: Array<CGPoint>) -> Float {

	// calculate area of the convex polygon
	var area: Float = 0.0
	for var count = 1; count < sortedCop.count - 1; count++ {
		let a = Float(sortedCop[0].x * sortedCop[count].y + sortedCop[count].x * sortedCop[count+1].y + sortedCop[count+1].x * sortedCop[0].y)
		let b = Float(sortedCop[0].x * sortedCop[count+1].y + sortedCop[count].x * sortedCop[0].y + sortedCop[count+1].x * sortedCop[count].y)
		let single_area = abs(a - b) / 2
		area = area + single_area
	}
	return area
}

func reSizeImage(image: UIImage, toSize reSize: CGSize) -> UIImage {
	UIGraphicsBeginImageContextWithOptions(reSize, false, UIScreen.mainScreen().scale)
	image.drawInRect(CGRectMake(0, 0, reSize.width, reSize.height))
	let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
	UIGraphicsEndImageContext()
	return scaledImage
}

func saveUserDefaultsInfo() {
	//userDefaults.setInteger(userid, forKey: "id")
	userDefaults.setObject(userimageData, forKey: "headImage")
	userDefaults.setObject(username, forKey: "name")
	userDefaults.setInteger(usersex, forKey: "sex")
	userDefaults.setInteger(userage, forKey: "age")
	userDefaults.setInteger(userheight, forKey: "height")
	userDefaults.setInteger(userweight_main, forKey: "weight_main")
	userDefaults.setInteger(userweight_fraction, forKey: "weight_fraction")
	userDefaults.setFloat(userweight, forKey: "weight")
	userDefaults.setInteger(userbust, forKey: "bust")
	userDefaults.setInteger(userwaist, forKey: "waist")
	userDefaults.setInteger(userhip, forKey: "hip")
}

func getUserInfo() -> Int{
	var code = -1
	let urlPath = "\(url_prefix)getUserInfo.php?id=\(userid)"
	print("usrlPath: \(urlPath)")
	let url = NSURL(string: urlPath)
	let session = NSURLSession.sharedSession()
	let request = NSURLRequest(URL: url!)
	//print("start session")
	// get
//	let semaphore = dispatch_semaphore_create(0)
	
	let task = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
		if error != nil {
			//if error.l
			print(error!.localizedDescription)
			print("session error: \(error!.code)")
			code = (error?.code)!
		} else {
//			let result = NSString(data: data!, encoding: NSUTF8StringEncoding)
//			print("result: \(result)")
			//print("start json decode")
			// json decode
			do {
				let jsonResult = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)
				//print("info json result: \(jsonResult)")
				let status = jsonResult.objectForKey("status") as! Int
				//print("status: \(status)")
				if status == 0 {
					//let userData = jsonResult.objectForKey("data")
					let userInfo = jsonResult.objectForKey("userInfo")
					if userInfo != nil{
						code = 0
						print("userInfo not nil")
						username = userInfo!.objectForKey("name") as! String
						usersex = (userInfo!.objectForKey("sex") as! NSString).integerValue
						userage = (userInfo!.objectForKey("age") as! NSString).integerValue
						userheight = (userInfo!.objectForKey("height") as! NSString).integerValue
						userweight_main = (userInfo!.objectForKey("weight_main") as! NSString).integerValue
						userweight_fraction = (userInfo!.objectForKey("weight_fraction") as! NSString).integerValue
						userweight = (userInfo!.objectForKey("weight") as! NSString).floatValue
						userbust = (userInfo!.objectForKey("bust") as! NSString).integerValue
						userwaist = (userInfo!.objectForKey("waist") as! NSString).integerValue
						userhip = (userInfo!.objectForKey("hip") as! NSString).integerValue
						
						saveUserDefaultsInfo()
					} else {
						code = 1
						
					}
				}
				
			} catch {
				print("json error")
			}
		}
//		dispatch_semaphore_signal(semaphore)
	}
	task.resume()
	
//	dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
	
	return code
}

func getTestRecord() -> Int{
	var code = -1
	let urlPath = "\(url_prefix)getTestRecord.php?id=\(userid)"
	print("usrlPath: \(urlPath)")
	let url = NSURL(string: urlPath)
	let session = NSURLSession.sharedSession()
	let request = NSURLRequest(URL: url!)
	//print("start session")
	// get
	let task = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
		if error != nil {
			//if error.l
			print(error!.localizedDescription)
			print("session error: \(error!.code)")
			code = (error?.code)!
		} else {
//			let result = NSString(data: data!, encoding: NSUTF8StringEncoding)
//			
//			print("result: \(result)")
			//print("start json decode")
			// json decode
			do {
				let jsonResult = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)
//				print("test record json result: \(jsonResult)")
				
				code = 0
				//let userData = jsonResult.objectForKey("data")
				let testRecordData = jsonResult.objectForKey("testRecord")
				if testRecordData != nil {
					
					let totalNumber = testRecordData!.count
					var whole = Array<Array<String>>()
					var count = 0
					while count < totalNumber{
						let single = testRecordData!.objectForKey("'\(count)'")
						var temp = Array<String>()
						
						for var i = 0; i < testIndexNumber; i++ {
							temp.append(single?.objectForKey("\(i+2)") as! String)
						}
						whole.append(temp)
						count += 1
						if count % 4 == 0 {
							whole.append([single?.objectForKey("8") as! String, single?.objectForKey("9") as! String])
							testRecord.append(whole)
							whole = Array<Array<String>>()
						}
					}
					
					userDefaults.setObject(testRecord, forKey: "testRecord")
				} else {
					testRecord = Array<Array<Array<String>>>()
				}
				
			} catch {
				print("json error")
			}
		}
	}
	task.resume()
	return code
}

func getTrainingRecord() -> Int{
	var code = -1;
	
	let urlPath = "\(url_prefix)getTrainingRecord.php?id=\(userid)"
	print("usrlPath: \(urlPath)")
	let url = NSURL(string: urlPath)
	let session = NSURLSession.sharedSession()
	let request = NSURLRequest(URL: url!)
	//print("start session")
	// get
	let task = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
		if error != nil {
			//if error.l
			print(error!.localizedDescription)
			print("session error: \(error!.code)")
			code = (error?.code)!
		} else {
			let result = NSString(data: data!, encoding: NSUTF8StringEncoding)
			
			print("result: \(result)")
			//print("start json decode")
			// json decode
			do {
				let jsonResult = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)
				print("training json result: \(jsonResult)")
				
				code = 0
				//let userData = jsonResult.objectForKey("data")
				let trainingRecordData = jsonResult.objectForKey("trainingRecord")
				if trainingRecordData != nil{
					
					let totalNumber = trainingRecordData!.count
					var count = 0
					while count < totalNumber{
						let single = trainingRecordData!.objectForKey("'\(count)'")
						var temp = Array<String>()
						
						for var i = 0; i < 8; i++ {
							temp.append(single?.objectForKey("\(i+1)") as! String)
						}
						trainingRecord.append(temp)
						count += 1
					}
					
//					trainingRecord = trainingRecordData as! Array<Array<String>>
					userDefaults.setObject(trainingRecord, forKey: "trainingRecord")
				} else {
					trainingRecord = Array<Array<String>>()
				}
			} catch {
				print("json error")
			}
		}
	}
	task.resume()
	return code
}

func getImage(){
//	var image = UIImage()
	
	let urlPath = "\(url_prefix)picture/\(userid).png"
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
									userimageData = data
									userimage = UIImage(data: userimageData)
//					image = UIImage(data: data!)!
//					print("get image")
				} else {
					userimage = UIImage(named: "head")
					userimageData = UIImagePNGRepresentation(userimage)
				}
				
			}
//		})

	}
	task.resume()
//	return image
}



func getAllUserInfoServer() -> Int{
	var code = 0
	let code0 = getUserInfo()
	print("code0: \(code0)")
	if code0 == 0 {
		print("get user info successfully")
		saveUserDefaultsInfo()
	} else if code0 == 1 {
		print("user info not complete")
	} else if code0 == -1 {
		code = -1
	}
	let code1 = getTestRecord()
	print("code1: \(code1)")
	if code1 == 0 {
		print("get test record successfully")
	} else if code1 == -1 {
		code = -1
	}
	let code2 = getTrainingRecord()
	print("code2: \(code2)")
	if code2 == 0 {
		print("get training record successfully")
	} else if code2 == -1 {
		code = -1
	}
	
	getImage()
	
//	let code3 = getImage()
//	if code3 == 0 {
//		print("get image successfully")
//	} else {
//		userimage = UIImage(named: "head")
//		userimageData = UIImagePNGRepresentation(userimage)
//	}
	
//	if userimage == nil {
//		userimage = UIImage(named: "head")
//		print("user image nil")
//	}
//	userimageData = UIImagePNGRepresentation(userimage)
//	userDefaults.setObject(userimageData, forKey: "headImage")
	print("code: \(code)")
	return code
}

/*
func setStatusBarBackgroundColor(color: UIColor) {
	guard let statusBar = UIApplication.sharedApplication().valueForKey("statusBarWindow")?.valueForKey("statusBar") as? UIView else {
		return
	}
	statusBar.backgroundColor = color;

}
*/








































