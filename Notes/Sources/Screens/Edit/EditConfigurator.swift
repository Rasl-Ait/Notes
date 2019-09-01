//
//  EditConfigurator.swift
//  Notes
//
//  Created by rasl on 31/08/2019.
//  Copyright © 2019 com.rasl. All rights reserved.
//

import Foundation

protocol EditConfiguratorProtocol {
	func configure(editViewController: EditViewController)
}

class EditConfigurator: EditConfiguratorProtocol {
	func configure(editViewController: EditViewController) {
		let router = EditViewRouter(editViewController: editViewController)
		let presenter = EditViewPresenter(view: editViewController, router: router, editContainerView: editViewController.editContainerView)
		editViewController.presenter = presenter
	}
}


