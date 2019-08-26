//
//  LoadNotesBackendOperation.swift
//  Notes
//
//  Created by rasl on 26/08/2019.
//  Copyright © 2019 com.rasl. All rights reserved.
//

import Foundation

enum LoadNotesBackendResult {
	case success([Note])
	case failure(NetworkError)
}

class LoadNotesBackendOperation: BaseBackendOperation {
	var result: LoadNotesBackendResult?
	
	init(notes: [Note]) {
		super.init()
	}
	
	override func main() {
		result = .failure(.unreachable)
		self.state = .finished
	}
}

