//
//  EditViewController.swift
//  Notes
//
//  Created by rasl on 19/08/2019.
//  Copyright © 2019 com.rasl. All rights reserved.
//

import UIKit

class EditViewController: UIViewController {
	@IBOutlet weak var scrollView: UIScrollView!
	@IBOutlet weak var editContainerView: EditContainerView!
	
	private var color: UIColor?
	private var uid: String?
	
	var note: Note?
	var fileNotebook: FileNotebook?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setup()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(keyboardWillShowHide(notification:)),
			name: UIResponder.keyboardWillShowNotification, object: nil
		)
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(keyboardWillShowHide(notification:)),
			name: UIResponder.keyboardWillHideNotification, object: nil
		)
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		NotificationCenter.default.removeObserver(
			self,
			name: UIResponder.keyboardWillShowNotification,
			object: nil
		)
		NotificationCenter.default.removeObserver(
			self,
			name: UIResponder.keyboardWillChangeFrameNotification,
			object: nil
		)
		saveNote()
	}
}

// MARK: - Private extension EditViewController
private extension EditViewController {
	func setup() {
		title = note != nil ? "Редактирование" : "Новая заметка"
		addTapGesture()
		uid = UUID().uuidString
		scrollView.keyboardDismissMode = .interactive
		updateUI()
		
		editContainerView.colorDidChange = { [weak self] color in
			guard let `self` = self else { return }
			self.color = color
		}
		
		editContainerView.colorPickerViewClicked = { [weak self] in
			guard let `self` = self else { return }
			self.pushColorPicker()
		}
	}
	
	func pushColorPicker() {
		let colorPickerController = ColorPickerViewController()
		colorPickerController.delegate = self
		colorPickerController.color = editContainerView.bColor
		self.navigationController?.pushViewController(colorPickerController, animated: true)
	}
	
	func updateUI() {
		editContainerView.set(
			title: note?.title ?? "",
			content: note?.content ?? editContainerView.contentText!,
			color: note?.color ?? editContainerView.bColor, date:
			note?.destructionDate
		)
	}
	
	func updateNote() {
		guard
			let note = note,
			let title = editContainerView.titleText, !title.isEmpty,
			let content = editContainerView.contentText, !content.isEmpty
			else { return }
		
		let updateNote = Note(
			uid: note.uid,
			title: title,
			content: content,
			color: self.color ?? note.color,
			importance: .normal,
			destructionDate: editContainerView.date
		)
		
		guard let notebook = fileNotebook else { return }
		
		let saveNoteOperation = SaveNoteOperation(
			note: updateNote,
			notebook: notebook,
			backendQueue: backendQueue,
			dbQueue: dbQueue
		)
		commonQueue.addOperation(saveNoteOperation)
	}
	
	func newNote() {
		guard
			let uid = uid,
			let title = editContainerView.titleText, !title.isEmpty,
			let content = editContainerView.contentText, !content.isEmpty
			else { return }
		
		let note = Note(uid: uid, title: title,
										content: content,
										color: color ?? .white ,
										importance: .normal,
										destructionDate: editContainerView.date
		)
		
		guard let notebook = fileNotebook else { return }
		
		let saveNoteOperation = SaveNoteOperation(
			note: note,
			notebook: notebook,
			backendQueue: backendQueue,
			dbQueue: dbQueue
		)
		
		commonQueue.addOperation(saveNoteOperation)
	}
	
	func saveNote() {
		note != nil ? updateNote() : newNote()
	}
	
	// MARK: - Actions
	
	@objc func keyboardWillShowHide(notification: Notification) {
		guard let userInfo = notification.userInfo else { return }
		let safeAreaBottom = view.safeAreaInsets.bottom
		if let keyboardSize = (
			userInfo[UIResponder.keyboardFrameEndUserInfoKey]
				as? NSValue)?.cgRectValue {
			let keyboardViewEndFrame = view.convert(keyboardSize, from: view.window)
			if notification.name == UIResponder.keyboardWillHideNotification {
				scrollView.contentInset = .zero
			} else {
				if #available(iOS 11.0, *) {
					self.scrollView.contentInset = UIEdgeInsets(
						top: 0,
						left: 0,
						bottom: keyboardViewEndFrame.height + safeAreaBottom,
						right: 0
					)
				} else {
					self.scrollView.contentInset = UIEdgeInsets(
						top: 0,
						left: 0,
						bottom: keyboardViewEndFrame.height,
						right: 0
					)
				}
			}
		}
		view.layoutIfNeeded()
	}
	
	func addTapGesture() {
		// Gesture
		let tapGesture =  UITapGestureRecognizer(
			target: self,
			action: #selector(hideKeyboard)
		)
		view.addGestureRecognizer(tapGesture)
	}
	
	@objc func hideKeyboard() {
		self.view.endEditing(true)
	}
}

extension EditViewController: ColorPickerViewControllerDelegate {
	func handleColor(color: UIColor) {
		self.color = color
		editContainerView.setBackgroundColor(color: color)
	}
}
