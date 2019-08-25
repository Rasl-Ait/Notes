
import UIKit

class CustomTextField: UITextField {
	
	let insets: UIEdgeInsets
	
	init(insets: UIEdgeInsets) {
		self.insets = insets
		super.init(frame: .zero)
	
		layer.cornerRadius = 5
		layer.borderWidth =  0.5
		layer.borderColor = UIColor.lightGray.cgColor
		placeholder = "Enter title for your note"
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func textRect(forBounds bounds: CGRect) -> CGRect {
		return bounds.inset(by: insets)
	}
	
	override func editingRect(forBounds bounds: CGRect) -> CGRect {
		return bounds.inset(by: insets)
	}
}
