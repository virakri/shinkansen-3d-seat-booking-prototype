//
//  DesignValues.swift
//  Shinkansen Tickets Booking Prototype
//
//  Created by Virakri Jinangkul on 5/29/19.
//  Copyright © 2019 Virakri Jinangkul. All rights reserved.
//

import UIKit

extension DesignSystem {
    
    class opacity {
        static let highlighted: Float = 0.54
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
        class func card() -> NSDirectionalEdgeInsets {
            return .init(vertical: 12, horizontal: 16) }
        
        class func largeCard() -> NSDirectionalEdgeInsets {
            return .init(vertical: 20, horizontal: 16) }
    }
    
    class spacing {
        static let cardGutter: CGFloat = 16
    }
}
