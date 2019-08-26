//
//  GithubAPI.swift
//  Notes
//
//  Created by rasl on 26/08/2019.
//  Copyright © 2019 com.rasl. All rights reserved.
//

import Foundation

struct GithubAPI {
	static var token = ""
	static var id = ""
	static var rawUrl = ""
	static let filename = "ios-course-notes-db"
}

public enum HTTPMethod: String {
	case options = "OPTIONS"
	case get     = "GET"
	case head    = "HEAD"
	case post    = "POST"
	case put     = "PUT"
	case patch   = "PATCH"
	case delete  = "DELETE"
	case trace   = "TRACE"
	case connect = "CONNECT"
}
