//
//  ColorView.swift
//  Notes
//
//  Created by rasl on 20/08/2019.
//  Copyright © 2019 com.rasl. All rights reserved.
//

import UIKit

class ColorView: UIView {
	private let checkmark = СheckmarkView()
	private let pickerView = PickerView()
	
	var isCheckmark: Bool = false {
		didSet {
			checkmark.isHidden = !isCheckmark
		}
	}
	
	var color: UIColor? {
		didSet {
			backgroundColor = color
			updateColorPalette()
		}
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupViews()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setupViews()
	}
	
	private func setupViews() {
		self.layerBorder()
		addChecmarkView()
		addColorPickerView()
	}
	
	private func addChecmarkView() {
		checkmark.translatesAutoresizingMaskIntoConstraints = false
		checkmark.isHidden = true
		addSubview(checkmark)
		
		[checkmark.topAnchor.constraint(equalTo: self.topAnchor, constant: Offset.top),
		 checkmark.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: Offset.trailing),
		 checkmark.heightAnchor.constraint(equalToConstant: Size.height),
		 checkmark.widthAnchor.constraint(equalToConstant: Size.width)]
			.forEach { $0.isActive = true }
	}
	
	private func addColorPickerView() {
		pickerView.translatesAutoresizingMaskIntoConstraints = false
		addSubview(pickerView)
		
		[pickerView.topAnchor.constraint(equalTo: self.topAnchor),
		 pickerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
		 pickerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
		 pickerView.bottomAnchor.constraint(equalTo: self.bottomAnchor)]
			.forEach { $0.isActive = true }
	}
	
	func updateColorPalette() {
		pickerView.isHidden = color != nil && color != UIColor.clear
	}
}

extension ColorView {
	struct Offset {
		static let trailing: CGFloat = -4
		static let top: CGFloat = 3
	}
	
	struct Size {
		static let width: CGFloat = 20
		static let height: CGFloat = 20
	}
}
