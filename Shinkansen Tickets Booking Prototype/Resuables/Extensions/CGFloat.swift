//
//  CGFloat.swift
//  Shinkansen Tickets Booking Prototype
//
//  Created by Virakri Jinangkul on 5/30/19.
//  Copyright © 2019 Virakri Jinangkul. All rights reserved.
//

import UIKit

extension CGFloat {
    public func pixelRounded() -> CGFloat {
        let scale = UIScreen.main.scale
        return (self * scale).rounded() / scale
    }
}
