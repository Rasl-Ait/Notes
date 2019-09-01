//
//  NotesConfigurator.swift
//  Notes
//
//  Created by rasl on 31/08/2019.
//  Copyright © 2019 com.rasl. All rights reserved.
//

import Foundation

protocol NotesConfiguratorProtocol {
	func configure(notesViewController: NotesViewController)
}

class NotesConfigurator: NotesConfiguratorProtocol {
	func configure(notesViewController: NotesViewController) {
		let router = NotesViewRouter(notesViewController: notesViewController)
		let presenter = NotesViewPresenter(view: notesViewController, router: router, database: notesViewController.database)
		notesViewController.presenter = presenter
	}
}

