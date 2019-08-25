//
//  NoteExtensions.swift
//  Notes
//
//  Created by rasl on 19/08/2019.
//  Copyright © 2019 com.rasl. All rights reserved.
//

import UIKit

extension Note {
	
	// Вычисляемое свойство для формирование json
	var json: [String: Any] {
		var dict = [String: Any]()
		dict["uid"] = self.uid
		dict["title"] = self.title
		dict["content"] = self.content
		
		if self.color != .white {
			dict["color"] = self.color.hexString
		}
		
		if self.importance != .normal {
			dict["importance"] = self.importance.rawValue
		}
		
		if let destructionDate = self.destructionDate {
			dict["destructionDate"] = destructionDate.timeIntervalSince1970
		}
		
		return dict
	}
	
	// Функция для разбора json
	static func parse(json: [String: Any]) -> Note? {
		guard
			let uid = json["uid"] as? String,
			let title = json["title"] as? String,
			let content = json["content"] as? String
			else { return nil }
		
		let color = json["color"] as? String ?? UIColor.white.hexString
		
		var improtance = Importance.normal
		if let improtanceString = json["improtance"] as? String,
			let impt = Importance(rawValue: improtanceString) {
			improtance = impt
		}
		
		var destructionDate: Date? = nil
		if let date = json["destructionDate"] as? TimeInterval {
			destructionDate = Date(timeIntervalSince1970: date)
		}
		
		return Note(uid: uid,
								title: title,
								content: content,
								color: UIColor(hexString: color),
								importance: improtance,
								destructionDate: destructionDate)
	}
}

