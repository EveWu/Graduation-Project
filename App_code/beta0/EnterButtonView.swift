//
//  EnterButtonView.swift
//  beta0
//
//  Created by wu xiao yue on 4/9/16.
//  Copyright © 2016 eve. All rights reserved.
//

import UIKit

@IBDesignable class EnterButtonView: UIButton {
	
	override func drawRect(rect: CGRect) {
		self.clearsContextBeforeDrawing = true
		
		// clip the round corner
		let path = UIBezierPath(roundedRect: rect, byRoundingCorners: UIRectCorner.AllCorners, cornerRadii: CGSize(width: 4.0, height: 4.0))
		path.addClip()
		
		UIColor.greenColor().setFill()
		path.fill()
		
		//let context = UIGraphicsGetCurrentContext()
		
		//CGContextClearRect(context, rect)
		/*
		let colors = [startColor.CGColor, endColor.CGColor]
		
		let colorSpace = CGColorSpaceCreateDeviceRGB()
		
		let colorLocations: [CGFloat] = [0.0, 1.0]
		
		let gradient = CGGradientCreateWithColors(colorSpace, colors, colorLocations)
		
		let startPoint = CGPoint.zero
		let endPoint = CGPoint(x: 0, y: self.bounds.height)
		CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, CGGradientDrawingOptions.init(rawValue: 0))
		*/
	}
}