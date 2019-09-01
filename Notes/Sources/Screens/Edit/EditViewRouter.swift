//
//  EditViewRouter.swift
//  Notes
//
//  Created by rasl on 31/08/2019.
//  Copyright © 2019 com.rasl. All rights reserved.
//

import UIKit

protocol EditViewRouterProtocol  {
	func pusthColorPikerView(color: UIColor, delegate: ColorPickerViewControllerDelegate)
}

class EditViewRouter {
	private weak var editViewController: EditViewController?
	
	init(editViewController: EditViewController) {
		self.editViewController = editViewController
	}
}

// MARK: - EditViewRouterProtocol
extension EditViewRouter: EditViewRouterProtocol {
	func pusthColorPikerView(color: UIColor, delegate: ColorPickerViewControllerDelegate) {
		let colorPickerController = ColorPickerViewController()
		colorPickerController.delegate = delegate
		colorPickerController.color = color
		editViewController?.navigationController?.pushViewController(colorPickerController, animated: true)
	}
}


