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
	static let clientId = "186360ce28f9005480f7" // здесь должен быть ID вашего зарегистрированного приложения
	static let clientSecret = "59bee110b7a9fe1f63907e94b66603d77064bbfb"
}
