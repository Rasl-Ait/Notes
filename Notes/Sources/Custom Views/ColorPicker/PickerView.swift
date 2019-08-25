//
//  PickerView.swift
//  Notes
//
//  Created by rasl on 21/08/2019.
//  Copyright © 2019 com.rasl. All rights reserved.
//

import UIKit

class PickerView: UIView {
	override init(frame: CGRect) {
		super.init(frame: frame)
		setup()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setup()
	}
	
	private func setup() {
		self.backgroundColor = .clear
	}

	override func draw(_ rect: CGRect) {
		super.draw(rect)
		let context = UIGraphicsGetCurrentContext()!
		for x in stride(from: bounds.minX, to: bounds.maxX, by: 1) {
			let xRatio = (x - bounds.minX) / bounds.width
			for y in stride(from: bounds.minY, to: bounds.maxY, by: 1) {
				let yRatio = (y - bounds.minY) / bounds.height
				
				let color = UIColor(
					hue: xRatio,
					saturation: 1 - yRatio,
					brightness: 1,
					alpha: 1
				)
				context.setFillColor(color.cgColor)
				context.fill(CGRect(x: x, y: y, width: 1, height: 1))
			}
		}
	}
}
