//
//  ColorPickerView.swift
//  Notes
//
//  Created by rasl on 20/08/2019.
//  Copyright © 2019 com.rasl. All rights reserved.
//

import UIKit

class ColorPalleteView: UIView {
	private let saturationExponentTop: Float = 0.5
	private let saturationExponentBottom: Float = 1
	
	private var lastSelectedColor = UIColor.white
	private var position: CGPoint = .zero
	private let pickerView = PickerView()
	
	var shapeSize: CGSize = CGSize(width: 30, height: 30) {
		didSet {
			setNeedsDisplay()
		}
	}
	
	var brightnessValue: CGFloat = 1.0 {
		didSet{
			setNeedsDisplay()
		}
	}
	
	let sightView = SightView()
	var colorDidChange: ItemClosure<UIColor>?
	
	// adjustable
	var elementSize: CGFloat = 1.0 {
		didSet {
			setNeedsDisplay()
		}
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setup()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setup()
	}
	
	private func setup() {
		self.clipsToBounds = true
		self.layerBorder()
		configurePickerView()
		self.addSubview(sightView)
		
		NotificationCenter.default.addObserver(self, selector: #selector(viewDidiRotate), name: UIDevice.orientationDidChangeNotification, object: nil)
	}
	
	deinit {
		NotificationCenter.default.removeObserver(self, name: UIDevice.orientationDidChangeNotification, object: nil)
	}
	
	func changeSightPosition(point: CGPoint, color: UIColor) {
		sightView.translatesAutoresizingMaskIntoConstraints = false
		sightView.frame = CGRect(origin: point, size: shapeSize)
		lastSelectedColor = color
	}
	
	func configurePickerView() {
		pickerView.translatesAutoresizingMaskIntoConstraints = false
		addSubview(pickerView)
		
		[pickerView.topAnchor.constraint(equalTo: topAnchor),
		 pickerView.leadingAnchor.constraint(equalTo: leadingAnchor),
		 pickerView.trailingAnchor.constraint(equalTo: trailingAnchor),
		 pickerView.bottomAnchor.constraint(equalTo: bottomAnchor)]
			.forEach { $0.isActive = true }
	}
	
	private func getColorAtPoint(point: CGPoint) -> UIColor {
		let saturation = 1.0 - point.y / self.bounds.height
		let hue = point.x / self.bounds.width
		return UIColor(hue: hue, saturation: saturation, brightness: brightnessValue, alpha: 1.0)
	}
	
	func getPointForColor(color:UIColor) -> CGPoint {
		var hue:CGFloat = 0
		var saturation:CGFloat = 0
		var brightness:CGFloat = 0
		color.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: nil);
		let yPos = (1.0 - saturation) * self.bounds.height
		let xPos = hue * self.bounds.width
		return CGPoint(x: xPos, y: yPos)
	}
	
	override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
		super.touchesMoved(touches, with: event)
		guard let touch = touches.first else { return }
		let touchPoint = touch.location(in: self)
		let color = getColorAtPoint(point: touchPoint)
		changeSightPosition(point: touchPoint, color: color)
		colorDidChange?(color)
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		super.touchesBegan(touches, with: event)
		guard let touch = touches.first else { return }
		let touchPoint = touch.location(in: self)
		let color = getColorAtPoint(point: touchPoint)
		changeSightPosition(point: touchPoint, color: color)
		colorDidChange?(color)
	}
	
	@objc private func viewDidiRotate(notification: Notification) {
		let point = getPointForColor(color: lastSelectedColor)
		changeSightPosition(point: point, color: lastSelectedColor)
	}
}
