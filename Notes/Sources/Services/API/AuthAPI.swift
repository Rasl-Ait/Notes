//
//  AuthAPI.swift
//  Notes
//
//  Created by rasl on 28/08/2019.
//  Copyright © 2019 com.rasl. All rights reserved.
//

import Foundation

class AuthAPI {
	static let authorize = "https://github.com/login/oauth/authorize"
  static let tokenPath = "https://github.com/login/oauth/access_token"
	static let gist = "gist"
	static let callback = "ioscoursenotes" // схема для callback
	static let clientId = "" // здесь должен быть ID вашего зарегистрированного приложения
	static let clientSecret = ""
}
