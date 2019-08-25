//
//  ColorPickerViewController.swift
//  Notes
//
//  Created by rasl on 20/08/2019.
//  Copyright © 2019 com.rasl. All rights reserved.
//

import UIKit

protocol ColorPickerViewControllerDelegate: class {
	func handleColor(color: UIColor)
}

class ColorPickerViewController: UIViewController {
	@IBOutlet weak var containerView: ContainerView!
	@IBOutlet weak var colorPickerView: ColorPalleteView!
	
	weak var delegate: ColorPickerViewControllerDelegate?
	
	var color: UIColor!
	private var value: CGFloat = 0.90
	
	override func viewDidLoad() {
		super.viewDidLoad()
		title = "Color Picker"
		update()
		
		colorPickerView.colorDidChange = { [weak self ] color in
			guard let `self` = self else { return }
			self.color = color
			
			self.containerView.setBackgroundColorViewAndColorLabel(
				self.color, text:
				color.hexString,
				value: self.value)
			
		}
	}
	
	private func update() {
		self.containerView.setBackgroundColorViewAndColorLabel(
			self.color, text:
			color.hexString,
			value: self.value)
		
		let point = colorPickerView.getPointForColor(
			color: color
		)
		
		self.colorPickerView.changeSightPosition(point: point, color: color)
	}
	
	@IBAction func doneButtonTapped(_ sender: UIButton) {
		self.delegate?.handleColor(color: color)
		self.navigationController?.popViewController(animated: true)
	}
}
