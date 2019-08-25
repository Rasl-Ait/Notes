//
//  NotesTableViewCell.swift
//  Notes
//
//  Created by rasl on 25/08/2019.
//  Copyright © 2019 com.rasl. All rights reserved.
//

import UIKit

class NotesTableViewCell: UITableViewCell {
	@IBOutlet weak var notesViewCell: NotesViewCell!
	
	static var height: CGFloat { return 150 }
	
	override func awakeFromNib() {
		super.awakeFromNib()
	}
	
	override func prepareForReuse() {
		super.prepareForReuse()
		notesViewCell.prepareReuse()
	}
	
	override func setSelected(_ selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
	}
	
	func configure(note: Note) {
		notesViewCell.set(
			viewColor: note.color,
			name: note.title,
			content: note.content
		)
	}
}
