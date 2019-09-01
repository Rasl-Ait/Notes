import Foundation

class SaveNoteDBOperation: BaseDBOperation {
	private let note: Note
	
	init(note: Note, database: NoteStorageProtocol) {
		self.note = note
		super.init(database: database)
	}
	
	override func main() {
		database.add(note)
		database.saveToFile()
		self.state = .finished
	}
}
