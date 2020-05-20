import Foundation

class SaveNoteDBOperation: BaseDBOperation {
	private let note: Note
	
	init(note: Note, database: NoteStorageProtocol) {
		self.note = note
		super.init(database: database)
	}
	
	override func main() {
		DispatchQueue.global(qos: .background).async { [weak self] in
			guard let self = self else { return }
			self.database.add(self.note)
			self.state = .finished
		}
	}
}
