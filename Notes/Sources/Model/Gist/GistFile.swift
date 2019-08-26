//
//  GistFile.swift
//  Notes
//
//  Created by rasl on 26/08/2019.
//  Copyright © 2019 com.rasl. All rights reserved.
//

import Foundation

struct GistFile: Decodable {
	let filename: String
	let rawUrl: String
	
	enum CodingKeys: String, CodingKey {
		case filename
		case rawUrl = "raw_url"
	}
}

struct GistFileContent: Codable {
	let  content: String
}
