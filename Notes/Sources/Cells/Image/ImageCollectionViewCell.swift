//
//  ImageCollectionViewCell.swift
//  Notes
//
//  Created by rasl on 25/08/2019.
//  Copyright © 2019 com.rasl. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
	@IBOutlet weak var galleryImage: UIImageView!
	
	override func awakeFromNib() {
		super.awakeFromNib()
	}
	
	override func prepareForReuse() {
		super.prepareForReuse()
		galleryImage.image = nil
	}
}
