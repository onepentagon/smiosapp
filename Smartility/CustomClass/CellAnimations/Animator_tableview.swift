//
//  Animator.swift
//  UITableViewCellAnimation-Article
//
//  Created by Vadym Bulavin on 9/4/18.
//  Copyright © 2018 Vadim Bulavin. All rights reserved.
//

import UIKit

final class Animator_tableview {
	private var hasAnimatedAllCells = false
	private let animation: Animation_fac

	init(animation: @escaping Animation_fac) {
		self.animation = animation
	}

	func animate(cell: UITableViewCell, at indexPath: IndexPath, in tableView: UITableView) {
		guard !hasAnimatedAllCells else {
			return
		}

		animation(cell, indexPath, tableView)

		hasAnimatedAllCells = tableView.isLastVisibleCell(at: indexPath)
	}
}
