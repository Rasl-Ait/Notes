//
//  ImageViewerCollectionViewCell.swift
//  Notes
//
//  Created by rasl on 25/08/2019.
//  Copyright © 2019 com.rasl. All rights reserved.
//

import UIKit

class ImageViewerCollectionViewCell: UICollectionViewCell {
	@IBOutlet weak var scrollView: UIScrollView!
	@IBOutlet weak var galleryImageView: UIImageView!
	
	var minZoomScale: CGFloat {
		let viewSize = bounds.size
		let widthScale = viewSize.width / galleryImageView.bounds.width
		let heightScale = viewSize.height / galleryImageView.bounds.height
		return min(widthScale, heightScale)
	}
	
	override func awakeFromNib() {
		super.awakeFromNib()
		setupViews()
	}
	
	func configure(_ model: Image) {
		let path = FileManager.getDocumentsDirectory().appendingPathComponent(model.originalImage)
		let image = UIImage(contentsOfFile: path.path)
		galleryImageView.image = image
	}
}

// MARK: - Private Extension

private extension ImageViewerCollectionViewCell {
	func setupViews() {
		scrollView.delegate = self
		scrollView.minimumZoomScale = 1.0
		scrollView.maximumZoomScale = 4.5
		let tap = UITapGestureRecognizer(target: self, action: #selector(doubleTouches(recognizer:)))
		tap.numberOfTapsRequired = 2
		self.addGestureRecognizer(tap)
	}
	
	@objc func doubleTouches(recognizer: UITapGestureRecognizer) {
		scrollView.zoomScale = 1.0
		backgroundColor = .white
	}
}

// MARK: - UIScrollViewDelegate
extension ImageViewerCollectionViewCell: UIScrollViewDelegate {
	func viewForZooming(in scrollView: UIScrollView) -> UIView? {
		return galleryImageView
	}
	
	func scrollViewDidZoom(_ scrollView: UIScrollView) {
		backgroundColor = .black
		if scrollView.zoomScale < minZoomScale {
			backgroundColor = .white
		}
	}
}
