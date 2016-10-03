//
//  mainTabBarController.swift
//  beta0
//
//  Created by wu xiao yue on 4/7/16.
//  Copyright © 2016 eve. All rights reserved.
//

import UIKit

class mainTabBarController: UITabBarController {
	
	override func viewDidLoad() {
		super.viewDidLoad()
		/*
		var test = TestViewController()
	  var testItem = UITabBarItem(title: "测试", image: UIImage(named: "testItem"), selectedImage: UIImage(named: "testItemSelected"))
		var testNav = UINavigationController(rootViewController: test)
		*/
		//setStatusBarBackgroundColor(UIColor.whiteColor())
		let userViewController = self.viewControllers![2]
		let userItem = reSizeImage(UIImage(named: "user")!, toSize: CGSize(width: 28, height: 28))
		let userItemSelected = reSizeImage(UIImage(named: "userSelected")!, toSize: CGSize(width: 28, height: 28))
		userViewController.tabBarItem = UITabBarItem(title: "我", image: userItem.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal), selectedImage: userItemSelected.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal))
		userViewController.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName:purple_deep], forState: UIControlState.Selected)
		//usertabBarItem.tabBarItem.setTitleTextAttributes([String : ]?, forState: UIControlState.Selected)
		//self.setViewControllers(<#T##viewControllers: [UIViewController]?##[UIViewController]?#>, animated: true)
		let testViewController = self.viewControllers![0]
		let testItem = reSizeImage(UIImage(named: "test")!, toSize: CGSize(width: 28, height: 28))
		let testItemSelected = reSizeImage(UIImage(named: "testSelected")!, toSize: CGSize(width: 28, height: 28))
		testViewController.tabBarItem = UITabBarItem(title: "测试", image: testItem.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal), selectedImage: testItemSelected.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal))
		testViewController.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName:purple_deep], forState: UIControlState.Selected)
		
		let trainViewController = self.viewControllers![1]
		let trainItem = reSizeImage(UIImage(named: "train")!, toSize: CGSize(width: 28, height: 17))
		let trainItemSelected = reSizeImage(UIImage(named: "trainSelected")!, toSize: CGSize(width: 28, height: 17))
		trainViewController.tabBarItem = UITabBarItem(title: "训练", image: trainItem.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal), selectedImage: trainItemSelected.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal))
		trainViewController.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName:purple_deep], forState: UIControlState.Selected)
		
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(true)
		//UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: UIStatusBarAnimation.Fade)
		
	}
	
	override func prefersStatusBarHidden() -> Bool {
		return false
	}
}
