//
//  UITableView.swift
//  Shinkansen Tickets Booking Prototype
//
//  Created by Virakri Jinangkul on 6/1/19.
//  Copyright © 2019 Virakri Jinangkul. All rights reserved.
//

import UIKit

extension UITableView {
    func setupTheme() {
        visibleCells.forEach { (cell) in
            if let cell = cell as? TrainScheduleTableViewCell {
                cell.setupTheme()
            }
        }
    }
}
