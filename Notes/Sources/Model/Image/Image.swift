//
//  Image.swift
//  Notes
//
//  Created by rasl on 25/08/2019.
//  Copyright © 2019 com.rasl. All rights reserved.
//

import UIKit

struct Image: Equatable {
	let uid: String
	let originalImage: String
	let thumbImage: String
	
	public init(uid : String = UUID().uuidString,
							originalImage: String,
							thumbImage: String) {
		self.uid = uid
		self.originalImage = originalImage
		self.thumbImage = thumbImage
	}
}

extension Image {
	// Вычисляемое свойство для формирование json
	var json: [String: Any] {
		var dict = [String: Any]()
		dict["uid"] = self.uid
		dict["image"] = self.originalImage
		dict["thumbImage"] = self.thumbImage
		return dict
	}
	
	// Функция для разбора json
	static func parse(json: [String: Any]) -> Image? {
		guard
			let uid = json["uid"] as? String,
			let image = json["image"] as? String,
			let thumbImage = json["thumbImage"] as? String
			else { return nil }
		
		return Image(uid: uid, originalImage: image, thumbImage: thumbImage)
	}
}
