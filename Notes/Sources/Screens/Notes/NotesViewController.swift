//
//  NotesViewController.swift
//  Notes
//
//  Created by rasl on 25/08/2019.
//  Copyright © 2019 com.rasl. All rights reserved.
//

import UIKit

protocol NotesView: class {
	func refreshNotesView()
	func deleteAnimated(row: Int)
}

class NotesViewController: UIViewController {
	@IBOutlet weak var tableView: UITableView!
	
	var presenter: NotesViewPresenterProtocol!
	var configurator: NotesConfiguratorProtocol!
	var database: NoteStorageProtocol!
	
	init(configurator: NotesConfiguratorProtocol, database: NoteStorageProtocol!) {
		self.configurator = configurator
		self.database = database
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		configurator.configure(notesViewController: self)
		setup()
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		presenter.viewDidAppear()
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
		setupRefreshControl()
		showAuthController()
	}
	
	func setupTableView() {
		tableView.dataSource = self
		tableView.delegate = self
		tableView.separatorStyle = .none
		tableView.register(cellType: NotesTableViewCell.self)
	}
	
	func setupRefreshControl() {
		let refreshControl = UIRefreshControl()
		refreshControl.addTarget(self, action: #selector(loadNotesOperation), for: .valueChanged)
		tableView.refreshControl = refreshControl
		tableView.refreshControl?.beginRefreshing()
	}
	
	@objc func loadNotesOperation() {
		presenter.viewDidLoad()
	}
	
	func setupNavigationBar() {
		navigationItem.leftBarButtonItem = editButtonItem
		navigationItem.rightBarButtonItem = UIBarButtonItem(
			barButtonSystemItem: .add, target: self,
			action: #selector(addBarButtonClicked)
		)
	}
	
	@objc func addBarButtonClicked() {
		presenter.addButtonPressed()
	}
	
	func tabBarIsHidden(_ bool: Bool) {
		self.tabBarController?.tabBar.isHidden = bool
	}
	
	func showAuthController() {
		guard !UserDefaults.token.isEmpty else {
			let authView = AuthViewController()
			authView.delegate = self
			self.present(authView, animated: true, completion: nil)
			return
		}
		presenter.loadNotesOperation()
	}
}

// MARK: - NotesView
extension NotesViewController: NotesView {
	func deleteAnimated(row: Int) {
		tableView.deleteRows(at: [IndexPath(row: row, section:0)], with: .automatic)
	}
	
	func refreshNotesView() {
		tableView.reloadData()
		tableView.refreshControl?.endRefreshing()
	}
}

// MARK: - UITableViewDataSource
extension NotesViewController: UITableViewDataSource {
	func tableView( _ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return presenter.numberOfNotes
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell: NotesTableViewCell = tableView.dequeueCell(for: indexPath)
		presenter.configure(cell: cell, forRow: indexPath.row)
		return cell
	}
	
	func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		return tableView.isEditing
	}
	
	func tableView(_ tableView: UITableView, commit editingStyle:
		UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		guard editingStyle == .delete else { return }
		presenter.delete(row: indexPath.row)
	}
}

// MARK: - UITableViewDelegate
extension NotesViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		presenter.didSelect(row: indexPath.row)
		tabBarIsHidden(true)
		tableView.deselectRow(at: indexPath, animated: false)
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return UITableView.automaticDimension
	}
	
	func tableView( _ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
		return NotesTableViewCell.height
	}
}

// MARK: - AuthViewControllerDelegate
extension NotesViewController: AuthViewControllerDelegate {
	func handleTokenChanged(token: String) {
		UserDefaults.setToken(token)
	}
}
