//
//  NotesViewCell.swift
//  Notes
//
//  Created by rasl on 22/08/2019.
//  Copyright © 2019 com.rasl. All rights reserved.
//

import UIKit

class NotesViewCell: UIView {
	private let titleLabel = UILabel.titleLabel
	private let contentLabel = UILabel.contentLabel
	private let backgroundView = UIView()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupViews()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setupViews()
	}
	
	func set(viewColor: UIColor, name: String, content: String) {
		titleLabel.text = name
		backgroundView.backgroundColor = viewColor
		contentLabel.text = content
	}
	
	func prepareReuse() {
		titleLabel.text = ""
		contentLabel.text = ""
	}
}

// MARK: Private extension NotesViewCell
private extension NotesViewCell {
	func setupViews() {
		addSubview()
		configureContent()
	}
	
	func addSubview() {
		[self.backgroundView,
		 self.titleLabel,
		 self.contentLabel].forEach {
			self.addSubview($0)
		}
	}
	
	func configureContent() {
		configureBackroundView()
		configureTitleLabel()
		configureContentLabel()
	}

	func configureBackroundView() {
		backgroundView.translatesAutoresizingMaskIntoConstraints = false
		backgroundView.layer.borderWidth = 0.3
		backgroundView.layer.borderColor = UIColor.black.cgColor
		
		[backgroundView.topAnchor.constraint(equalTo: self.topAnchor, constant: Offset.top - 4),
		 backgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Offset.leading),
		 backgroundView.widthAnchor.constraint(equalToConstant: Size.width),
		 backgroundView.heightAnchor.constraint(equalToConstant: Size.height)]
			.forEach { $0.isActive = true }
	}
	
	func configureTitleLabel() {
		titleLabel.translatesAutoresizingMaskIntoConstraints = false
		[titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: Offset.top),
		 titleLabel.leadingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: Offset.leading),
		 titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant:  Offset.trailing - 8)]
			.forEach { $0.isActive = true }
	}
	
	func configureContentLabel() {
		contentLabel.translatesAutoresizingMaskIntoConstraints = false
		[contentLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Offset.bottom),
		 contentLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Offset.leading),
		 contentLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant:  Offset.trailing),
		 contentLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: Offset.bottom - 13)]
			.forEach { $0.isActive = true }
	}
}

extension NotesViewCell {
	struct Offset {
		static let leading: CGFloat = 16.0
		static let trailing: CGFloat = -16.0
		static let top: CGFloat = 20.0
		static let bottom: CGFloat = 18
	}
	
	struct Size {
		static let width: CGFloat = 40
		static let height: CGFloat = 40
	}
}


