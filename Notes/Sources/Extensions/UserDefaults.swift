//
//  UserDefaults.swift
//  Notes
//
//  Created by rasl on 26/08/2019.
//  Copyright © 2019 com.rasl. All rights reserved.
//

import Foundation

struct UserDefaultsKeys {
	static let token = "token"
	static let gistID = "id"
}

extension UserDefaults {
	static var token: String {
		let userDefaults = UserDefaults.standard
		return userDefaults.string(forKey: UserDefaultsKeys.token) ?? ""
	}
	
	static var gistID: String {
		let userDefaults = UserDefaults.standard
		return userDefaults.string(forKey: UserDefaultsKeys.gistID) ?? ""
	}
	
	static func setToken(_ token: String) {
		let userDefaults = UserDefaults.standard
		userDefaults.set(token, forKey: UserDefaultsKeys.token)
	}
	
	static func setGistID(_ gistID: String) {
		let userDefaults = UserDefaults.standard
		userDefaults.set(gistID, forKey: UserDefaultsKeys.gistID)
	}
	
	static func removeToken() {
		let userDefaults = UserDefaults.standard
		userDefaults.removeObject(forKey: UserDefaultsKeys.token)
	}
	
	static func removeGistID() {
		let userDefaults = UserDefaults.standard
		userDefaults.removeObject(forKey: UserDefaultsKeys.gistID)
	}
}

