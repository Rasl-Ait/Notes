
import UIKit

extension UITableView {
	func register<Cell: UITableViewCell>(cellType: Cell.Type,
																			 nib: Bool = true) {
		
		let reuseIdentifier = Cell.name
		
		if nib {
			let nib = UINib(nibName: reuseIdentifier, bundle: nil)
			register(nib, forCellReuseIdentifier: reuseIdentifier)
		} else {
			register(cellType, forCellReuseIdentifier: reuseIdentifier)
		}
	}
	
	func dequeueCell<T: UITableViewCell>(for indexPath: IndexPath) -> T {
		guard let cell = dequeueReusableCell(withIdentifier: T.name, for: indexPath) as? T else {
			fatalError("Unable to Dequeue Reusable Table View Cell")
		}
		return cell
	}
}
