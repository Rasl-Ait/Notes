
import UIKit

class CustomTextView: UITextView {

	private let insetsTextView = UIEdgeInsets(top: 10, left: 5, bottom: 0, right: 12)
	
	override init(frame: CGRect, textContainer: NSTextContainer?) {
		super.init(frame: frame, textContainer: textContainer)
		initialSetup()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		initialSetup()
	}
	
	private func initialSetup() {
		isScrollEnabled = false
		text = "Enter content text"
		font = UIFont.systemFont(ofSize: 15)
		textContainerInset = insetsTextView
		layer.cornerRadius = 5
		layer.borderWidth = 0.5
		layer.borderColor = UIColor.lightGray.cgColor
		delegate = self
		textViewDidChange(self)
	}
}

// MARK: - UITextViewDelegate
extension CustomTextView: UITextViewDelegate {
	func textViewDidChange(_ textView: UITextView) {
		let size = CGSize(width: self.frame.width, height: .infinity)
		let estimatedSize = textView.sizeThatFits(size)
		
		textView.constraints.forEach { (constraint) in
			if constraint.firstAttribute == .height {
				constraint.constant = estimatedSize.height
			}
		}
	}
}
