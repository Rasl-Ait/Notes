//
//  Gist.swift
//  Notes
//
//  Created by rasl on 26/08/2019.
//  Copyright © 2019 com.rasl. All rights reserved.
//

import Foundation

struct Gist: Decodable {
	let description: String
	let files: [String : GistFile]
	let `public`: Bool!
	let id: String
}

