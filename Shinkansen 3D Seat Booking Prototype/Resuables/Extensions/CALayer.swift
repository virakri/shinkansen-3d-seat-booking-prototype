//
//  CALayer.swift
//  Shinkansen Tickets Booking Prototype
//
//  Created by Virakri Jinangkul on 6/4/19.
//  Copyright © 2019 Virakri Jinangkul. All rights reserved.
//

import UIKit
import Kumi

extension CALayer {
    var layerStyle: LayerStyle {
        return LayerStyle(opacity: opacity,
                          masksToBounds: masksToBounds,
                          mask: mask,
                          isDoubleSided: isDoubleSided,
                          cornerRadius: cornerRadius,
                          borderWidth: borderWidth,
                          borderColor: borderColor,
                          backgroundColor: backgroundColor,
                          shadowPath: shadowPath,
                          shadowStyle: ShadowStyle(shadowOpacity: shadowOpacity,
                                                   shadowRadius: shadowRadius,
                                                   shadowOffset: shadowOffset,
                                                   shadowColor: shadowColor),
                          shadowColor: shadowColor,
                          transform: transform,
                          isRectangularShadow: false)
    }
    
    var shadowStyle: ShadowStyle {
        return ShadowStyle(shadowOpacity: shadowOpacity,
                           shadowRadius: shadowRadius,
                           shadowOffset: shadowOffset,
                           shadowColor: shadowColor)
    }
    
    func withNoShadow() {
        shadowOpacity = 0
        shadowRadius = 0
        shadowOffset = .zero
        shadowColor = nil
    }
    
    func setShadow(_ shadowStyle: ShadowStyle) {
        shadowOpacity = shadowStyle.shadowOpacity
        shadowRadius = shadowStyle.shadowRadius
        shadowOffset = shadowStyle.shadowOffset
        shadowColor = shadowStyle.shadowColor
    }
}
