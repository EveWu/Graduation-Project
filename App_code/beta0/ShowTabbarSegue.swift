//
//  ShowTabbarSegue.swift
//  beta0
//
//  Created by wu xiao yue on 4/8/16.
//  Copyright © 2016 eve. All rights reserved.
//

import UIKit

class ShowTabbarSegue: UIStoryboardSegue {
	override func perform() {
		let firstViewController: LaunchViewController = self.sourceViewController as! LaunchViewController
		let secondViewController: UITabBarController = self.destinationViewController as! UITabBarController
		UIView.animateWithDuration(1, delay: 0, options: UIViewAnimationOptions.TransitionFlipFromRight, animations: { () -> Void in
			firstViewController.presentViewController(secondViewController, animated: true, completion: nil)
			}, completion: nil)
	}
}
