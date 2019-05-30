//
//  NSDirectionalEdgeInsets.swift
//  Shinkansen Tickets Booking Prototype
//
//  Created by Virakri Jinangkul on 5/30/19.
//  Copyright © 2019 Virakri Jinangkul. All rights reserved.
//

import UIKit

extension NSDirectionalEdgeInsets {
    init(vertical: CGFloat, horizontal: CGFloat) {
        self.init(top: vertical,
              leading: horizontal,
              bottom: vertical,
              trailing: horizontal)
    }
}
