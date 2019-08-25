//
//  AppDelegate.swift
//  Notes
//
//  Created by rasl on 19/08/2019.
//  Copyright © 2019 com.rasl. All rights reserved.
//

import UIKit
import CocoaLumberjack

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

	func application(
		_ application: UIApplication,
		didFinishLaunchingWithOptions launchOptions:
		[UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		setupLogger()
		
		window = UIWindow(frame: UIScreen.main.bounds)
		window?.makeKeyAndVisible()
		let navigatorController =  UINavigationController(
			rootViewController: EditViewController()
		)
		window?.rootViewController = navigatorController
		
		return true
	}
	
	private func setupLogger() {
		DDLog.add(DDOSLogger.sharedInstance) // Uses os_log
		let fileLogger: DDFileLogger = DDFileLogger()
		fileLogger.rollingFrequency = TimeInterval(60 * 60 * 24)
		fileLogger.logFileManager.maximumNumberOfLogFiles = 7
		DDLog.add(fileLogger)
	}

	func applicationWillResignActive(_ application: UIApplication) {}

	func applicationDidEnterBackground(_ application: UIApplication) {}

	func applicationWillEnterForeground(_ application: UIApplication) {}

	func applicationDidBecomeActive(_ application: UIApplication) {}

	func applicationWillTerminate(_ application: UIApplication) {}
}

