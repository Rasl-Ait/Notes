
import UIKit

class SightView: UIView {
	
	let indent: CGFloat = 5
	
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
		
		  let circle = UIBezierPath(
				arcCenter: CGPoint(
				x: rect.midX,
				y: rect.midY),
				radius: rect.midX - indent,
				startAngle: 0, endAngle: .pi * 2.0,
				clockwise: true)
		
		UIColor.black.setStroke()
		circle.lineWidth = 1
		circle.stroke()
		
		let path = UIBezierPath()
		path.move(to: CGPoint(x: rect.midX, y: indent))
		path.addLine(to: CGPoint(x: rect.midX, y: 0))
	
		path.move(to: CGPoint(x: indent, y: rect.midY))
		path.addLine(to: CGPoint(x: 0, y: rect.midY))
		
		path.move(to: CGPoint(x: rect.maxX, y: rect.midY))
		path.addLine(to: CGPoint(x: rect.maxX - indent, y: rect.midY))
		
		path.move(to: CGPoint(x: rect.midX, y: rect.maxY))
		path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY - indent))
		
		UIColor.black.setStroke()
		path.lineWidth = 1
		path.stroke()
	}
}
