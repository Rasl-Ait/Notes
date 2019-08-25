
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
	
	func dequeueCell<Cell: UITableViewCell>(of cellType: Cell.Type,
																							 for indexPath: IndexPath) -> Cell {
		
		return dequeueReusableCell(withIdentifier: Cell.name,
															 for: indexPath) as! Cell
	}
}
