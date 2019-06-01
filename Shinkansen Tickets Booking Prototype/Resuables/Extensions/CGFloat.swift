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
    
    public func systemSizeMuliplier() -> CGFloat {
        let multiplier: CGFloat = UIFontMetrics(forTextStyle: .body).scaledFont(for: .systemFont(ofSize: 256)).pointSize / 256
        return (self * multiplier).pixelRounded()
    }
    
//    public func systemSizeMuliplier(withMaximum maximum: CGFloat) -> CGFloat {
//        return (self.systemSizeMuliplier()).pixelRounded()
//    }
}
