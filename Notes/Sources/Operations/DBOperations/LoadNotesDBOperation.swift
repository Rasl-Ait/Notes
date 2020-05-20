//
//  LoadNotesDBOperation.swift
//  Notes
//
//  Created by rasl on 26/08/2019.
//  Copyright © 2019 com.rasl. All rights reserved.
//

import Foundation

class LoadNotesDBOperation: BaseDBOperation {
	private(set) var result: [Note]?
	
	override func main() {
		DispatchQueue.global(qos: .background).async { [weak self] in
			guard let self = self else { return }
			let notes = self.database.loadFromFile()
			self.result = notes
			self.state = .finished
		}
	}
}

