//
//  NotesViewController.swift
//  Notes
//
//  Created by rasl on 25/08/2019.
//  Copyright © 2019 com.rasl. All rights reserved.
//

import UIKit

class NotesViewController: UIViewController {
	@IBOutlet weak var tableView: UITableView!
	
	let fileNotebook = FileNotebook()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setup()
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		fileNotebook.loadFromFile()
		tableView.reloadData()
		self.tabBarIsHidden(false)
	}
	
	override func setEditing(_ editing: Bool, animated: Bool) {
		super.setEditing(editing, animated: animated)
		tableView.isEditing = editing
	}
}

// MARK: - Extension NotesViewController
private extension NotesViewController {
	func setup() {
		setupTableView()
		setupNavigationBar()
		
	}
	
	func setupTableView() {
		tableView.dataSource = self
		tableView.delegate = self
		tableView.separatorStyle = .none
		tableView.register(cellType: NotesTableViewCell.self)
	}
}

// MARK: - UITableViewDataSource
extension NotesViewController: UITableViewDataSource {
	func tableView( _ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return fileNotebook.notes.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueCell(of: NotesTableViewCell.self, for: indexPath)
		let note = fileNotebook.notes[indexPath.row]
		cell.configure(note: note)
		return cell
	}
	
	func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		return tableView.isEditing
	}
	
	func tableView(_ tableView: UITableView, commit editingStyle:
		UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		guard editingStyle == .delete else { return }
		let note = fileNotebook.notes[indexPath.row]
		fileNotebook.remove(with: note.uid)
		fileNotebook.saveToFile()
		tableView.deleteRows(at: [indexPath], with: .automatic)
	}
	
	func setupNavigationBar() {
		navigationItem.leftBarButtonItem = editButtonItem
		navigationItem.rightBarButtonItem = UIBarButtonItem(
			barButtonSystemItem: .add, target: self,
			action: #selector(addBarButtonClicked)
		)
	}
	
	@objc func addBarButtonClicked() {
		let editController = EditViewController()
		editController.fileNotebook = fileNotebook
		tabBarIsHidden(true)
		navigationController?.pushViewController(editController, animated: true)
	}
	
	func tabBarIsHidden(_ bool: Bool) {
		self.tabBarController?.tabBar.isHidden = bool
	}
}

// MARK: - UITableViewDelegate
extension NotesViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		pushEdit(index: indexPath.row)
		tableView.deselectRow(at: indexPath, animated: false)
	}
	
	private func pushEdit(index: Int) {
		let editController = EditViewController()
		let note = fileNotebook.notes[index]
		editController.note = note
		editController.fileNotebook = fileNotebook
		tabBarIsHidden(true)
		navigationController?.pushViewController(editController, animated: true)
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return UITableView.automaticDimension
	}
	
	func tableView( _ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
		return NotesTableViewCell.height
	}
}

