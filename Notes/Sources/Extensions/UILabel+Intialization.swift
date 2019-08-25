
import UIKit.UILabel

extension UILabel {
	static var titleLabel: UILabel {
		let label = UILabel(frame: .zero)
		label.font = UIFont.boldSystemFont(ofSize: 18)
		label.textColor = UIColor.black
		label.numberOfLines = 1
		return label
	}
	
	static var contentLabel: UILabel {
		let label = UILabel(frame: .zero)
		label.font = UIFont.systemFont(ofSize: 14)
		label.textColor = .gray
		label.numberOfLines = 5
		return label
	}
	
	static var  dateLabel: UILabel {
		let label = UILabel(frame: .zero)
		label.font = UIFont.systemFont(ofSize: 17)
		label.text = "Use Destroy Date:"
		return label
	}
	
	static var colorLabel: UILabel {
		let label = UILabel(frame: .zero)
		label.text = "#3dc440"
		label.textColor = .black
		label.textAlignment = .center
		return label
	}
	
	static var brightnessLabel: UILabel {
		let label = UILabel(frame: .zero)
		label.text = "Brightness:"
		label.textColor = .black
		return label
	}
	
	static var opacityLabel: UILabel {
		let label = UILabel(frame: .zero)
		label.text = "0.70%"
		label.textColor = .black
		return label
	}
}
