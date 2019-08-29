//
//  HTTPMethods.swift
//  Notes
//
//  Created by rasl on 28/08/2019.
//  Copyright © 2019 com.rasl. All rights reserved.
//

import Foundation

public enum HTTPMethods: String {
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
