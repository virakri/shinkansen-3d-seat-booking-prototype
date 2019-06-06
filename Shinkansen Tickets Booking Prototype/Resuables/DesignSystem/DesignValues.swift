//
//  DesignValues.swift
//  Shinkansen Tickets Booking Prototype
//
//  Created by Virakri Jinangkul on 5/29/19.
//  Copyright © 2019 Virakri Jinangkul. All rights reserved.
//

import UIKit

extension DesignSystem {
    
    static let isNarrowScreen = UIScreen.main.bounds.width <= 320
    
    class opacity {
        static let highlighted: Float = 0.54
        static let disabled: Float = 0.25
    }
    
    class alpha {
        static let highlighted: CGFloat = 0.54
        static let disabled: CGFloat = 0.25
    }
    
    class borderWidth {
        static let outlinedButton: CGFloat = 1
    }
    
    class radiusCorner {
        class func button() -> CGFloat { return CGFloat(8).systemSizeMuliplier() }
        
        class func card() -> CGFloat { return CGFloat(8).systemSizeMuliplier() }
        class func largeCard() -> CGFloat { return CGFloat(20).systemSizeMuliplier() }
    }
    
    class edgeInsets {
        class func button() -> UIEdgeInsets {
            return .init(of: CGFloat(18).systemSizeMuliplier()) }
        
        class func outlinedButton() -> UIEdgeInsets {
            return .init(vertical: CGFloat(8).systemSizeMuliplier(),
                         horizontal: CGFloat(20).systemSizeMuliplier()) }
    }
    
    class layoutMargins {
        class func itemCardControl() -> NSDirectionalEdgeInsets {
            return .init(vertical: 8, horizontal: 8) }
        
        class func card() -> NSDirectionalEdgeInsets {
            return .init(vertical: 12, horizontal: 16) }
        
        class func largeCard() -> NSDirectionalEdgeInsets {
            return .init(vertical: 20, horizontal: 16) }
    }
    
    class CATransform {
        static let normal: CATransform3D = CATransform3DIdentity
        static let highlighted: CATransform3D = CATransform3DMakeScale(0.98, 0.98, 1)
    }
    
    class spacing {
        static let cardGutter: CGFloat = 16
    }
    
    class layout {
        static let maximumWidth: CGFloat = 540
    }
}
