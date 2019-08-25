//
//  ColorPickerView.swift
//  Notes
//
//  Created by rasl on 20/08/2019.
//  Copyright © 2019 com.rasl. All rights reserved.
//

import UIKit

class ContainerView: UIView {
	// View
	private let containerColorView = UIView()
	private let colorView = UIView()
	
	// Label
	private let colorLabel = UILabel.colorLabel
	private let brightnessLabel = UILabel.brightnessLabel
	private let opacityLabel = UILabel.opacityLabel
	
	// Stack View
	private let brightnessStackView = UIStackView()
	
	// Slider
	private let brightnessSlider = UISlider()
	
	//
	var sliderValueDidChange: ItemClosure<CGFloat>?
	var colorDidChange: ItemClosure<UIColor>?
	var colorDid: ItemClosure<UIColor>?
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupViews()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setupViews()
	}
	
	func setBackgroundColorViewAndColorLabel(_ color: UIColor, text: String, value: CGFloat) {
		colorView.backgroundColor = color
		colorView.backgroundColor = colorView.backgroundColor?.withAlphaComponent(value)
		colorLabel.text = text
	}
}

// MARK: - Private extension ColorPickerView
private extension ContainerView {
	func setupViews() {
		addSubview()
		configureContent()

	}
	
	func addSubview() {
		[containerColorView,
		 brightnessStackView]
			.forEach { addSubview($0) }
	}

	// MARK: - Configure Content
	
	func configureContent() {
		configureContainerColorView()
		configureColorView()
		configureColorLabel()
		congigureBrightnessStackView()
		congigureBrightnessSlider()
	}
	
	func configureContainerColorView() {
		containerColorView.translatesAutoresizingMaskIntoConstraints = false
		containerColorView.layer.cornerRadius = 7
		containerColorView.layerBorder()
		containerColorView.layer.masksToBounds = true
		containerColorView.addSubview(colorView)
		containerColorView.addSubview(colorLabel)
		
		// Constraints
		
		[containerColorView.topAnchor.constraint(equalTo: topAnchor, constant: Offset.top),
		 containerColorView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Offset.leading),
		 containerColorView.heightAnchor.constraint(equalToConstant: 130),
			containerColorView.widthAnchor.constraint(equalToConstant: Size.width)]
			.forEach { $0.isActive = true }
	}
	
	func configureColorView() {
		colorView.translatesAutoresizingMaskIntoConstraints = false
		colorView.backgroundColor = #colorLiteral(red: 0.2443916202, green: 0.7679420114, blue: 0.2499805391, alpha: 0.6999678938)
		colorView.layerBorder()

		// Constraints
		
		[colorView.topAnchor.constraint(equalTo: containerColorView.topAnchor),
		 colorView.leadingAnchor.constraint(equalTo: containerColorView.leadingAnchor),
		 colorView.trailingAnchor.constraint(equalTo: containerColorView.trailingAnchor),
		 colorView.heightAnchor.constraint(equalToConstant: 105)].forEach { $0.isActive = true }
	}
	
	func configureColorLabel() {
		colorLabel.translatesAutoresizingMaskIntoConstraints = false
		
		// Constraints
		
		[colorLabel.topAnchor.constraint(equalTo: colorView.bottomAnchor, constant: 4),
		 colorLabel.leadingAnchor.constraint(equalTo: containerColorView.leadingAnchor),
		 colorLabel.trailingAnchor.constraint(equalTo: containerColorView.trailingAnchor),
		 colorLabel.trailingAnchor.constraint(equalTo: containerColorView.trailingAnchor)]
			.forEach { $0.isActive = true }
	}
	
	func congigureBrightnessStackView() {
		brightnessStackView.translatesAutoresizingMaskIntoConstraints = false
		brightnessStackView.axis = .vertical
		brightnessStackView.alignment = .leading
		brightnessStackView.distribution = .fill
		brightnessStackView.spacing = 0
		
		let stackView = UIStackView()
		stackView.axis = .horizontal
		stackView.alignment = .leading
		stackView.distribution = .fill
		stackView.spacing = 10
		
		stackView.addArrangedSubview(brightnessLabel)
		stackView.addArrangedSubview(opacityLabel)
		brightnessStackView.addArrangedSubview(stackView)
		brightnessStackView.addArrangedSubview(brightnessSlider)
		
		[brightnessStackView.topAnchor.constraint(equalTo: topAnchor, constant: Offset.top + 40),
		 brightnessStackView.leadingAnchor.constraint(equalTo: containerColorView.trailingAnchor, constant: Offset.leading),
		 brightnessStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: Offset.trailing),
			brightnessStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20)]
			.forEach { $0.isActive = true }
	}
	
	
	func congigureBrightnessSlider() {
		brightnessSlider.translatesAutoresizingMaskIntoConstraints = false
		brightnessSlider.minimumTrackTintColor = #colorLiteral(red: 0.01876759715, green: 0.4697211385, blue: 1, alpha: 0.7633775685)
		brightnessSlider.minimumValue = 0
		brightnessSlider.maximumValue = 1
		brightnessSlider.setValue(0.70, animated: false)
		//brightnessSlider.addTarget(self, action: #selector(sliderValueDidChange(_:)), for: .valueChanged)
		
		// Constraints
		
		[brightnessSlider.leadingAnchor.constraint(equalTo: brightnessStackView.leadingAnchor),
		 brightnessSlider.trailingAnchor.constraint(equalTo: brightnessStackView.trailingAnchor)]
			.forEach { $0.isActive = true }
	}
}

extension ContainerView {
	struct Offset {
		static let leading: CGFloat = 16.0
		static let trailing: CGFloat = -16.0
		static let top: CGFloat = 15.0
		static let bottom: CGFloat = 20
	}
	
	struct Size {
		static let width: CGFloat = 120
		static let height: CGFloat = 150
	}
}

