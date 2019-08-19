//
//  ViewController.swift
//  Notes
//
//  Created by rasl on 19/08/2019.
//  Copyright © 2019 com.rasl. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		title = "Notes"
		view.backgroundColor = .white
		
		
		let note = Note(title: "Notes", content: "text", color: .red, importance: .normal, destructionDate: Date())
		
		let json = note.json
		let parse = Note.parse(json: json)
		print(parse ?? "")
		
		
	}
}

