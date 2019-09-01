//
//  NotesTableViewCell.swift
//  Notes
//
//  Created by rasl on 25/08/2019.
//  Copyright © 2019 com.rasl. All rights reserved.
//

import UIKit

protocol NotesCellView {
	func displayTitle(title: String)
	func displayContent(content: String)
	func displayColorView(color: UIColor)
}

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
}

extension NotesTableViewCell: NotesCellView {
	
	func displayTitle(title: String) {
		notesViewCell.setTitle(title: title)
	}
	
	func displayContent(content: String) {
		notesViewCell.setContentText(content: content)
	}
	
	func displayColorView(color: UIColor) {
		notesViewCell.setBackgroundView(color: color)
	}
}
