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
	}
}

// MARK: - Private extension EditViewController
private extension EditViewController {
	func setup() {
		addTapGesture()
		scrollView.keyboardDismissMode = .interactive
		
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
		editContainerView.setBackgroundColor(color: color)
	}
}
