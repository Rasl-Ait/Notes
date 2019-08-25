//
//  ImagePickerManager.swift
//  Notes
//
//  Created by rasl on 25/08/2019.
//  Copyright © 2019 com.rasl. All rights reserved.
//

import UIKit
import MobileCoreServices

protocol ImagePickerManagerDelegate: class {
	func manager(_ manager: ImagePickerManager, didPickImage image: UIImage)
}

class ImagePickerManager: NSObject {
	private let imagePickerController = UIImagePickerController()
	private let presentingController: UIViewController
	weak var delegate: ImagePickerManagerDelegate?
	
	init(presentingController: UIViewController) {
		self.presentingController = presentingController
		super.init()
		configure()
	}
	
	func presentImagePicker(animated: Bool) {
		presentingController.present( imagePickerController, animated: animated, completion: nil)
	}
	
	func dismissImagePicker(animated: Bool, completion: (() -> Void)?) {
		imagePickerController.dismiss( animated: animated, completion: completion)
	}
	
	private func configure() {
		if UIImagePickerController.isSourceTypeAvailable(.camera) {
			imagePickerController.sourceType = .camera
			imagePickerController.cameraDevice = .front
		} else {
			imagePickerController.sourceType = .photoLibrary
		}
		
		imagePickerController.mediaTypes = [kUTTypeImage as String]
		imagePickerController.delegate = self
	}
}

extension ImagePickerManager: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo
		info: [UIImagePickerController.InfoKey : Any]) {
		guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
		delegate?.manager(self, didPickImage: image)
	}
	
	func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
		dismissImagePicker(animated: true, completion: nil)
	}
}


