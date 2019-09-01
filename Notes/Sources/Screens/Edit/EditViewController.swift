//
//  EditViewController.swift
//  Notes
//
//  Created by rasl on 19/08/2019.
//  Copyright © 2019 com.rasl. All rights reserved.
//

import UIKit

protocol EditView: class {
	var note: Note? { get }
	var database: NoteStorageProtocol! { get }
	var color: UIColor? { get set }
}

class EditViewController: UIViewController, EditView {
	@IBOutlet weak var scrollView: UIScrollView!
	@IBOutlet weak var editContainerView: EditContainerView!
	
	var color: UIColor?
	private var uid: String?
	
	var note: Note?
	var database: NoteStorageProtocol!
	var presenter: EditViewPresenterProtocol!
	var configurator: EditConfiguratorProtocol!
	
	init(configurator: EditConfiguratorProtocol) {
		self.configurator = configurator
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
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
		presenter.viewWillDisappear()
	}
}

// MARK: - Private extension EditViewController
private extension EditViewController {
	func setup() {
		title = note != nil ? "Редактирование" : "Новая заметка"
		addTapGesture()
		uid = UUID().uuidString
		scrollView.keyboardDismissMode = .interactive
		configurator.configure(editViewController: self)
		presenter.viewDidLoad(delegate: self)
		presenter.confugure(note: note)
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

// MARK: - ColorPickerViewControllerDelegate
extension EditViewController: ColorPickerViewControllerDelegate {
	func handleColor(color: UIColor) {
		self.color = color
		editContainerView.setBackgroundColor(color: color)
	}
}
