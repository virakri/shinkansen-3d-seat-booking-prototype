//
//  UIEdgeInsets.swift
//  Shinkansen Tickets Booking Prototype
//
//  Created by Virakri Jinangkul on 6/1/19.
//  Copyright © 2019 Virakri Jinangkul. All rights reserved.
//

import UIKit

extension UIEdgeInsets {
    init(of inset: CGFloat) {
        self.init(top: inset,
                  left: inset,
                  bottom: inset,
                  right: inset)
    }
    
    init(vertical: CGFloat, horizontal: CGFloat) {
        self.init(top: vertical,
                  left: horizontal,
                  bottom: vertical,
                  right: horizontal)
    }
}
