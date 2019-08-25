//
//  GalleryViewController.swift
//  Notes
//
//  Created by rasl on 25/08/2019.
//  Copyright © 2019 com.rasl. All rights reserved.
//

import UIKit

class GalleryViewController: UIViewController {
	@IBOutlet weak var collectionView: UICollectionView!
	
	private let minItemSpacing: CGFloat = 4.0
	private let countCells: CGFloat = 3.0
	private let imageNotebook = ImageNotebook()

	
	lazy var imagePickerManager: ImagePickerManager = {
		let manager = ImagePickerManager(presentingController: self)
		manager.delegate = self
		return manager
	}()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		imageNotebook.loadFromFile()
		setup()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		tabBarIsHidden(false)
		navigationController?.navigationBar.prefersLargeTitles = true
	}
}

// MARK: Extension GalleryViewController
private extension GalleryViewController {
	func setup() {
		title = "Галерея"
		addRightBarButton()
		setupCollectionView()
		
		if imageNotebook.images.isEmpty {
			for i in 1...12 {
				guard let image = UIImage(named: "image\(i)") else { return }
				let model = imageNotebook.saveNewMemory(image: image)
				imageNotebook.add(model)
			}
			imageNotebook.saveToFile()
		}
	}
	
	func setupCollectionView() {
		collectionView?.register(cellType: ImageCollectionViewCell.self)
		collectionView?.dataSource = self
		collectionView?.delegate = self
		collectionView?.contentInset = UIEdgeInsets(
			top: 10, left: 1, bottom: 10, right: 1
		)
	}
	
	
	func addRightBarButton() {
		navigationItem.rightBarButtonItem = UIBarButtonItem(
			barButtonSystemItem: .add, target: self,
			action: #selector(addButtonClicked(_:))
		)
	}
	
	func tabBarIsHidden(_ bool: Bool) {
		self.tabBarController?.tabBar.isHidden = bool
	}
	
	@objc func addButtonClicked(_ sender: UIBarButtonItem) {
		imagePickerManager.presentImagePicker(animated: true)
	}
}

// MARK: UICollectionViewDataSource
extension GalleryViewController: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return imageNotebook.images.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell: ImageCollectionViewCell = collectionView.dequeueCell(for: indexPath)
		let model = imageNotebook.images[indexPath.row]
		let path = self.imageNotebook.load(filename: model.thumbImage)
		let image = UIImage(contentsOfFile: path.path)
		cell.galleryImage.image = image
		return cell
	}
}

// MARK: UICollectionViewDelegate
extension GalleryViewController: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		pushImageViewer(indexPath: indexPath)
		collectionView.deselectItem(at: indexPath, animated: true)
	}
	
	private func pushImageViewer(indexPath: IndexPath) {
		let imageViewerController = ImageViewerViewController()
		imageViewerController.models = imageNotebook.images
		imageViewerController.indexPath = indexPath
		imageViewerController.modalTransitionStyle = .crossDissolve
		navigationController?.pushViewController(imageViewerController, animated: true)
		tabBarIsHidden(true)
	}
}

// MARK: - UICollectionViewDelegateFlowLayout
extension GalleryViewController: UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout:
		UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		
		let frameCV = collectionView.frame
		let widthCell = frameCV.width / countCells
		let spasing = (countCells + 1) * minItemSpacing / countCells
		return CGSize(width: widthCell - spasing, height: 150)
	}
}

// MARK: - ImagePickerManagerDelegate
extension GalleryViewController: ImagePickerManagerDelegate {
	func manager(_ manager: ImagePickerManager, didPickImage image: UIImage) {
		let model = imageNotebook.saveNewMemory(image: image)
		imageNotebook.add(model)
		imageNotebook.saveToFile()
		collectionView.reloadData()
		manager.dismissImagePicker(animated: true , completion: nil)
	}
}
