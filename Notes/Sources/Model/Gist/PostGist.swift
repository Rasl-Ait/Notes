//
//  PostGist.swift
//  Notes
//
//  Created by rasl on 26/08/2019.
//  Copyright © 2019 com.rasl. All rights reserved.
//

import Foundation

struct PostGist: Codable {
	let `public`: Bool
	let description: String
	let files: [String: GistFileContent]
}
