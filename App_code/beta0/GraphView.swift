//
//  GraphView.swift
//  beta0
//
//  Created by wu xiao yue on 4/6/16.
//  Copyright © 2016 eve. All rights reserved.
//

import UIKit

@IBDesignable class GraphView: UIView {
	
	@IBInspectable var startColor: UIColor = purple_light
	@IBInspectable var endColor: UIColor = purple_deep
	var copArray = [CGPoint]()
	var polygon = [CGPoint]()
	var transformedPolygon = [CGPoint]()
	var transformedCop = [CGPoint]()
	var width: CGFloat!
	var height: CGFloat!
	let width_limit = 225	// 225mm
	var height_max: CGFloat = 0.0
	
	override func drawRect(rect: CGRect) {
		self.clearsContextBeforeDrawing = true

		width = rect.width
		height = rect.height
		// clip the round corner
		let path = UIBezierPath(roundedRect: rect, byRoundingCorners: UIRectCorner.AllCorners, cornerRadii: CGSize(width: 8.0, height: 8.0))
		path.addClip()
		
		let context = UIGraphicsGetCurrentContext()
		
		//CGContextClearRect(context, rect)
		
		let colors = [startColor.CGColor, endColor.CGColor]
		
		let colorSpace = CGColorSpaceCreateDeviceRGB()
		
		let colorLocations: [CGFloat] = [0.0, 1.0]
		
		let gradient = CGGradientCreateWithColors(colorSpace, colors, colorLocations)
		
		let startPoint = CGPoint.zero
		let endPoint = CGPoint(x: 0, y: self.bounds.height)
		CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, CGGradientDrawingOptions.init(rawValue: 0))
		
		if copArray.count > 0 {
			// calculate each CoP point position
			getXY()
			
			// draw lines
			UIColor.whiteColor().setFill()
			UIColor.whiteColor().setStroke()
			let graphPath = UIBezierPath()
			
			graphPath.moveToPoint(CGPoint(x: transformedCop[0].x, y: transformedCop[0].y))
			
			for count in 1..<transformedCop.count {
				let nextPoint = CGPoint(x: transformedCop[count].x, y: transformedCop[count].y)
				graphPath.addLineToPoint(nextPoint)
			}
			//CGContextSaveGState(context)
			//CGContextRestoreGState(context)
			graphPath.stroke()
			
			// draw polygon
			let polygonPath = UIBezierPath()
			polygonPath.moveToPoint(CGPoint(x: transformedPolygon[0].x, y: transformedPolygon[0].y))
			for count in 0..<transformedPolygon.count {
				var point = CGPoint(x: transformedPolygon[count].x, y: transformedPolygon[count].y)
				point.x -= 5.0 / 2
				point.y -= 5.0 / 2
				if count != 0 {
					let nextPoint = CGPoint(x: transformedPolygon[count].x, y: transformedPolygon[count].y)
					polygonPath.addLineToPoint(nextPoint)
				}
				let circle = UIBezierPath(ovalInRect: CGRect(origin: point, size: CGSize(width: 5.0, height: 5.0)))
				circle.fill()
			}
			polygonPath.closePath()
			polygonPath.stroke()
		}
		

		
	}
	
	func getXY() {
		transformedCop = [CGPoint]()
		transformedPolygon = [CGPoint]()
		for count in 0..<copArray.count {
			let new_x = width / 2 + copArray[count].x * (width / CGFloat(width_limit * 2))
			let new_y = height / 2 - copArray[count].y * (height / CGFloat(width_limit * 2))
			let new_position = CGPoint(x: new_x, y: new_y)
			transformedCop.append(new_position)
		}
		for count in 0..<polygon.count {
			let new_x = width / 2 + polygon[count].x * (width / CGFloat(width_limit * 2))
			let new_y = height / 2 - polygon[count].y * (height / CGFloat(width_limit * 2))
			let new_position = CGPoint(x: new_x, y: new_y)
			transformedPolygon.append(new_position)
			if new_y > height_max {
				height_max = new_y
			}
		}
	}
}
