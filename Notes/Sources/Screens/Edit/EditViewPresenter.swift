//
//  EditViewPresenter.swift
//  Notes
//
//  Created by rasl on 31/08/2019.
//  Copyright © 2019 com.rasl. All rights reserved.
//

import UIKit

protocol EditViewPresenterProtocol {
  func viewDidLoad(delegate: ColorPickerViewControllerDelegate)
	func viewWillDisappear()
	func confugure(note: Note?) 
}

class EditViewPresenter {
	private  weak var view: EditView?
	private let router: EditViewRouterProtocol
	private let editContainerView: EditContainerView
	
	private var uid: String?

	init(view: EditView, router: EditViewRouterProtocol, editContainerView: EditContainerView ) {
		self.router = router
		self.view = view
		self.editContainerView = editContainerView
	}
}

// MARK: - EditViewPresenterProtocol
extension EditViewPresenter: EditViewPresenterProtocol {
	func pushColorPicker(color: UIColor , delegate: ColorPickerViewControllerDelegate) {
		router.pusthColorPikerView(color: color, delegate: delegate)
	}
	
	
	func viewDidLoad(delegate: ColorPickerViewControllerDelegate) {
		uid = UUID().uuidString
		editContainerView.colorDidChange = { [weak self] color in
			guard let `self` = self else { return }
			self.view?.color = color
		}
		
		editContainerView.colorPickerViewClicked = { [weak self] in
			guard let `self` = self else { return }
			self.pushColorPicker(color: self.editContainerView.bColor, delegate: delegate)
		}
	}
	
	func confugure(note: Note?) {
		editContainerView.setTitle(title: note?.title ?? editContainerView.titleText!)
		editContainerView.setContentText(content: note?.content ?? editContainerView.contentText!)
		editContainerView.setBackgroundView(color: note?.color ?? editContainerView.bColor)
		editContainerView.setDate(date: note?.destructionDate)
	}
	
	func viewWillDisappear() {
		  saveNote()
	}
	
	func saveNote() {
		view?.note != nil ? updateNote() : addNewNote()
	}
	
	func addNewNote() {
		guard
			let uid = uid,
			let title = editContainerView.titleText, !title.isEmpty,
			let content = editContainerView.contentText, !content.isEmpty
			else { return }
		
		let newNote = Note(uid: uid, title: title,
											 content: content,
											 color: view?.color ?? .white ,
											 importance: .normal,
											 destructionDate: editContainerView.date
		)
		
		 saveNote(note: newNote)
	}
	
	func updateNote() {
		guard
			let note = view?.note,
			let title = editContainerView.titleText, !title.isEmpty,
			let content = editContainerView.contentText, !content.isEmpty
			else { return }
		
		
		
		let updateNote = Note(
			uid: note.uid,
			title: title,
			content: content,
			color: view?.color ?? note.color,
			importance: .normal,
			destructionDate: editContainerView.date
		)
		
		 saveNote(note: updateNote)
	}
	
	func saveNote(note: Note) {
		guard let database = view?.database else { return }
		let saveNoteOperation = SaveNoteOperation(
			note: note,
			database: database,
			backendQueue: backendQueue,
			dbQueue: dbQueue
		)
		
		commonQueue.addOperation(saveNoteOperation)
	}
}

