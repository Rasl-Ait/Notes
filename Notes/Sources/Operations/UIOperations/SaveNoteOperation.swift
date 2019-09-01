import Foundation

class SaveNoteOperation: AsyncOperation {
	private let saveToDb: SaveNoteDBOperation
	private let dbQueue: OperationQueue
	
		private(set) var result: SaveNotesBackendResult? = nil
	
	init(note: Note,
			 database: NoteStorageProtocol,
			 backendQueue: OperationQueue,
			 dbQueue: OperationQueue) {
		
		saveToDb = SaveNoteDBOperation(note: note, database: database)
		self.dbQueue = dbQueue
		
		super.init()
		
		saveToDb.completionBlock = {
			let saveToBackend = SaveNotesBackendOperation(notes: database.notes)
			saveToBackend.completionBlock = {
				self.result = saveToBackend.result
				self.state = .finished
			}
			backendQueue.addOperation(saveToBackend)
		}
	}
	
	override func main() {
		dbQueue.addOperation(saveToDb)
	}
}
