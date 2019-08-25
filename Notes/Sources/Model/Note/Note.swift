//
//  Note.swift
//  Notes
//
//  Created by rasl on 19/08/2019.
//  Copyright © 2019 com.rasl. All rights reserved.
//

import UIKit

struct Note {
	var uid: String
	var title: String
	var content: String
	let color: UIColor
	let importance: Importance
	let destructionDate: Date?
	
	init(uid: String = UUID().uuidString,
			 title: String,
			 content: String,
			 color: UIColor = .white,
			 importance: Importance,
			 destructionDate: Date? = nil )
	{
		self.uid = uid
		self.title = title
		self.content = content
		self.color = color
		self.importance = importance
		self.destructionDate = destructionDate
	}
	
	enum Importance: String {
		case unimportant
		case normal
		case important
	}
}

