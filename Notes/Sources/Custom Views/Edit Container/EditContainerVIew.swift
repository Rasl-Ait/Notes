//
//  EditContainerVIew.swift
//  Notes
//
//  Created by rasl on 19/08/2019.
//  Copyright © 2019 com.rasl. All rights reserved.
//

import UIKit

let insets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)

class EditContainerView: UIView {
	// Text
	private let titleTextField = CustomTextField(insets: insets)
	private let contentTextView = CustomTextView()
	
	// Label
	private let dateLabel = UILabel.dateLabel
	
	// Switch
	private let dateSwitch = UISwitch()
	
	// Stack View
	private let dateStackView = UIStackView()
	private let colorPickerStackView = UIStackView()
	
	// DatePicker
	private let datePicker = UIDatePicker()
	
	private var colors = [UIColor.white, UIColor.red, .green, .clear]
	private var colorViews = [ColorView]()
	
	//
	var colorPickerViewClicked: VoidClosure?
	
	var bColor = UIColor.green
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupViews()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setupViews()
	}
	
	func setBackgroundColor(color: UIColor) {
		bColor = color
		colorViews[3].color = color
		for colorButton in colorViews {
			colorButton.isCheckmark = colorButton == colorViews[3]
		}
	}
}

// MARK: Private
private extension EditContainerView {
	func setupViews() {
		addDatePicker()
		addSubview()
		configureContent()
		addTargets()
		
		colorViews[0].isCheckmark = true
	}
	
	func addSubview() {
		[titleTextField,
		 contentTextView,
		 dateStackView,
		 colorPickerStackView].forEach {
			self.addSubview($0)
		}
	}
	
	func addDatePicker() {
		datePicker.datePickerMode = .dateAndTime
		datePicker.isHidden = true
	}
	
	// MARK: - Configure Content
	
	func configureContent() {
		configureTitle()
		configureContentText()
		configureDateStackView()
		configureColorPickerStackView()
	}
	
	func configureTitle() {
		titleTextField.translatesAutoresizingMaskIntoConstraints = false
		[titleTextField.topAnchor.constraint(equalTo: self.topAnchor, constant: Offset.top),
		 titleTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Offset.leading),
		 titleTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: Offset.trailing),
		 titleTextField.heightAnchor.constraint(equalToConstant: Size.height)]
			.forEach { $0.isActive = true }
	}
	
	func configureContentText() {
		contentTextView.translatesAutoresizingMaskIntoConstraints = false
		[contentTextView.topAnchor.constraint(equalTo: self.titleTextField.bottomAnchor, constant: Offset.bottom),
		 contentTextView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Offset.leading),
		 contentTextView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: Offset.trailing),
		 contentTextView.heightAnchor.constraint(equalToConstant: Size.height)]
			.forEach { $0.isActive = true }
	}
	
	func configureDateStackView() {
		dateStackView.translatesAutoresizingMaskIntoConstraints = false
		dateStackView.axis = .vertical
		dateStackView.alignment = .leading
		dateStackView.distribution = .fill
		dateStackView.spacing = 0
		
		let stackView = UIStackView()
		stackView.axis = .horizontal
		stackView.alignment = .fill
		stackView.distribution = .fill
		stackView.spacing = 10
		
		stackView.addArrangedSubview(dateLabel)
		stackView.addArrangedSubview(dateSwitch)
		dateStackView.addArrangedSubview(stackView)
		dateStackView.addArrangedSubview(datePicker)
		
		// Constraints
		
		[dateStackView.topAnchor.constraint(equalTo: contentTextView.bottomAnchor, constant: Offset.top),
		 dateStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Offset.leading),
		 dateStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant:  Offset.trailing)]
			.forEach { $0.isActive = true }
	}
	
	func configureColorPickerStackView() {
		colorPickerStackView.translatesAutoresizingMaskIntoConstraints = false
		colorPickerStackView.axis = .horizontal
		colorPickerStackView.distribution = .fillProportionally
		colorPickerStackView.alignment = .fill
		colorPickerStackView.spacing = 5
		
		for i in colors.indices {
			let colorView = ColorView()
			colorView.tag = i
			colorView.color = colors[i]
			colorViews.append(colorView)
			colorPickerStackView.addArrangedSubview(colorView)
			colorView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewGestureTap(_:))))
		}
		
		let longGestureRecognizer = UILongPressGestureRecognizer(
			target: self,
			action: #selector(colorPickerPressGesture(sender:)))
		longGestureRecognizer.numberOfTouchesRequired = 1
		colorViews[3].addGestureRecognizer(longGestureRecognizer)
		
		// Constraints
		
		[colorPickerStackView.topAnchor.constraint(equalTo: dateStackView.bottomAnchor, constant: Offset.top),
		 colorPickerStackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
		 colorPickerStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -Offset.bottom),
		 colorPickerStackView.heightAnchor.constraint(equalToConstant: Size.height),
		 colorPickerStackView.widthAnchor.constraint(equalToConstant: Size.width)]
			.forEach{ $0.isActive = true }
	}
	
	// MARK: - Actions
	
	func addTargets() {
		dateSwitch.isOn = false
		dateSwitch.addTarget(self, action: #selector(switchDatePicker), for: .touchUpInside)
	}
	
	@objc func switchDatePicker() {
		dateSwitch.isOn == false ?
			datePicketAnimationHidden(true) :
			datePicketAnimationHidden(false)
	}
	
	@objc func viewGestureTap(_ tap: UITapGestureRecognizer) {
		//guard let index = tap.view?.tag else { return }
		//		let color = colorBackground(index: index)
		//		colorDidChange?(color)
		colorViews.forEach { colorView in
			colorView.isCheckmark = colorView == tap.view
		}
	}
	
	@objc func colorPickerPressGesture(sender: UILongPressGestureRecognizer) {
		if sender.state == .began {
			colorPickerViewClicked?()
		}
	}
	
	func datePicketAnimationHidden(_ bool: Bool) {
		UIView.animate(withDuration: 0.3) {
			self.datePicker.isHidden = bool
		}
	}
}

extension EditContainerView {
	struct Offset {
		static let leading: CGFloat = 16.0
		static let trailing: CGFloat = -16.0
		static let top: CGFloat = 20.0
		static let bottom: CGFloat = 20
	}
	
	struct Size {
		static let width: CGFloat = 300
		static let height: CGFloat = 44
	}
}
