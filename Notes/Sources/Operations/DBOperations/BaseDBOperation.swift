import Foundation

class BaseDBOperation: AsyncOperation {
	let database: NoteStorageProtocol
	
	init(database: NoteStorageProtocol) {
		self.database = database
		super.init()
	}
}
