//
//  ImageViewerViewController.swift
//  Notes
//
//  Created by rasl on 25/08/2019.
//  Copyright © 2019 com.rasl. All rights reserved.
//

import UIKit

class ImageViewerViewController: UIViewController {
	@IBOutlet weak var collectionView: UICollectionView!
	
	private let countCells: CGFloat = 1.0
	
	var models: [Image] = []
	var indexPath: IndexPath!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setup()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		tabBarIsHidden(false)
		navigationController?.navigationBar.prefersLargeTitles = false
	}
}

// MARK: Extension ImageViewerViewController
private extension ImageViewerViewController {
	func setup() {
		title = "Viewer"
		setupCollectionView()
	}
	
	func setupCollectionView() {
		collectionView?.register(cellType: ImageViewerCollectionViewCell.self)
		collectionView?.dataSource = self
		collectionView?.delegate = self
		
		collectionView?.performBatchUpdates(nil) { result in
			self.collectionView?.scrollToItem(
				at: self.indexPath,
				at: .centeredHorizontally, animated: false)
		}
	}
	
	func tabBarIsHidden(_ bool: Bool) {
		self.tabBarController?.tabBar.isHidden = bool
	}
}

// MARK: UICollectionViewDataSource
extension ImageViewerViewController: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return models.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell: ImageViewerCollectionViewCell = collectionView.dequeueCell(for: indexPath)
		let model = models[indexPath.row]
		cell.configure(model)
		return cell
	}
}

// MARK: UICollectionViewDelegate
extension ImageViewerViewController: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		collectionView.deselectItem(at: indexPath, animated: true)
	}
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ImageViewerViewController: UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout:
		UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		
		let frameCV = collectionView.frame
		let widthCell = frameCV.width / countCells
		let heightCell = frameCV.height
		return CGSize(width: widthCell, height: heightCell)
	}
}

