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

extension Comparable {
    /// <#Description#>
    ///
    /// - Parameter limits: <#limits description#>
    /// - Returns: <#return value description#>
    func clamped(to limits: ClosedRange<Self>) -> Self {
        return min(max(self, limits.lowerBound), limits.upperBound)
    }
}

extension Strideable where Stride: SignedInteger {
    func clamped(to limits: CountableClosedRange<Self>) -> Self {
        return min(max(self, limits.lowerBound), limits.upperBound)
    }
}
