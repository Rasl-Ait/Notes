//
//  AppDelegate.swift
//  Notes
//
//  Created by rasl on 19/08/2019.
//  Copyright © 2019 com.rasl. All rights reserved.
//

import UIKit
import CocoaLumberjack

let backendQueue = OperationQueue()
let dbQueue = OperationQueue()
let commonQueue = OperationQueue()

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions
		launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		setupLogger()
		setupDefaultColors()
		setupTabBarController()
		
		return true
	}
	
	private func setupLogger() {
		DDLog.add(DDOSLogger.sharedInstance) // Uses os_log
		let fileLogger: DDFileLogger = DDFileLogger()
		fileLogger.rollingFrequency = TimeInterval(60 * 60 * 24)
		fileLogger.logFileManager.maximumNumberOfLogFiles = 7
		DDLog.add(fileLogger)
	}
	
	func setupDefaultColors() {
		// Default color
		let textTintColor = #colorLiteral(red: 0.1764705882, green: 0.2235294118, blue: 0.2666666667, alpha: 1)
		let tintColor = UIColor.black
		
		// NavigationBar
		UINavigationBar.appearance().tintColor = tintColor
		UINavigationBar.appearance().titleTextAttributes = [
			NSAttributedString.Key.foregroundColor: textTintColor
		]
		
		if let barFont = UIFont(name: "HelveticaNeue-Bold", size: 30) {
			UINavigationBar.appearance().largeTitleTextAttributes = [
				NSAttributedString.Key.foregroundColor: textTintColor,
				NSAttributedString.Key.font: barFont
			]
		}
		
		// Tab Bar
		UITabBar.appearance().tintColor = tintColor
	}
	
	func setupTabBarController() {
		let tabBarController = UITabBarController()
		let notesController = NotesViewController()
		let galleryController = GalleryViewController()
		
		notesController.title = "Заметки"
		galleryController.title = "Галерея"
		
		notesController.tabBarItem = UITabBarItem(
			title: "Заметки",
			image: UIImage(named: "notes"),
			tag: 0)
		
		galleryController.tabBarItem  = UITabBarItem(
			title: "Галерея",
			image: UIImage(named: "gallery"),
			tag: 1)
		
		tabBarController.viewControllers = [
			notesController,
			galleryController]
			.map{ UINavigationController(rootViewController: $0) }
		
		window = UIWindow(frame: UIScreen.main.bounds)
		window?.makeKeyAndVisible()
		window?.rootViewController = tabBarController
		
	}


	func applicationWillResignActive(_ application: UIApplication) {}

	func applicationDidEnterBackground(_ application: UIApplication) {}

	func applicationWillEnterForeground(_ application: UIApplication) {}

	func applicationDidBecomeActive(_ application: UIApplication) {}

	func applicationWillTerminate(_ application: UIApplication) {}
}

