//
//  СheckmarkView.swift
//  Notes
//
//  Created by rasl on 20/08/2019.
//  Copyright © 2019 com.rasl. All rights reserved.
//

import UIKit

class СheckmarkView: UIView {
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupViews()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setupViews()
	}
	
	private func setupViews() {
		self.backgroundColor = .clear
	}
	
	override func draw(_ rect: CGRect) {
		let circle = UIBezierPath(
			arcCenter: CGPoint(x: rect.midX, y: rect.midY),
			radius: rect.midX - 1,
			startAngle: 0,
			endAngle: .pi * 2.0,
			clockwise: true
		)
		
		UIColor.black.setStroke()
		circle.lineWidth = 1
		circle.stroke()
		
		let path = UIBezierPath()
		path.move(to: CGPoint(x: rect.minX + 5, y: rect.midY))
		path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY - 5))
		path.addLine(to: CGPoint(x: rect.midX + rect.maxX - 14, y: rect.minY + 4))
		
		UIColor.black.setStroke()
		circle.lineWidth = 1
		path.stroke()
	}
}


