//
//  BackgroundView.swift
//  beta0
//
//  Created by wu xiao yue on 4/9/16.
//  Copyright © 2016 eve. All rights reserved.
//

import UIKit

@IBDesignable class BackgroundView: UIView {
	
	@IBInspectable var startColor: UIColor = UIColor.redColor()
	@IBInspectable var endColor: UIColor = UIColor.greenColor()
	
	override func drawRect(rect: CGRect) {
		self.clearsContextBeforeDrawing = true
		
		// clip the round corner
		//let path = UIBezierPath(roundedRect: rect, byRoundingCorners: UIRectCorner.AllCorners, cornerRadii: CGSize(width: 8.0, height: 8.0))
		//path.addClip()
		
		let context = UIGraphicsGetCurrentContext()
		
		//CGContextClearRect(context, rect)
		
		let colors = [startColor.CGColor, endColor.CGColor]
		
		let colorSpace = CGColorSpaceCreateDeviceRGB()
		
		let colorLocations: [CGFloat] = [0.0, 1.0]
		
		let gradient = CGGradientCreateWithColors(colorSpace, colors, colorLocations)
		
		let startPoint = CGPoint.zero
		let endPoint = CGPoint(x: 0, y: self.bounds.height)
		CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, CGGradientDrawingOptions.init(rawValue: 0))
	}
}
