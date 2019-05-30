//
//  LayerStyle.swift
//  Shinkansen Tickets Booking Prototype
//
//  Created by Virakri Jinangkul on 5/14/19.
//  Copyright © 2019 Virakri Jinangkul. All rights reserved.
//

import UIKit
import Kumi

extension LayerStyle {
    static let none = LayerStyle(opacity: 0)
    struct card {
        static let normal = LayerStyle(opacity: 1,
                                       cornerRadius: Constant.cardRadiusCorner,
                                       backgroundColor: currentColorTheme.component.cardBackground.cgColor,
                                       shadowStyle: ShadowStyle.card.normal
        )
        
        static let highlighted = normal.withShadowStyle(ShadowStyle.card.highlighted)
        
        static let disabled = normal.withShadowStyle(ShadowStyle.card.disabled)
        
    }
    
    struct largeCard {
        static let normal = LayerStyle(opacity: 1,
                                       cornerRadius: Constant.largeCardRadiusCorner,
                                       backgroundColor: currentColorTheme.component.cardBackground.cgColor, //currentColorTheme.component.cardBackground.cgColor,
                                       shadowStyle: ShadowStyle.card.normal
        )
        
        static let highlighted = normal.withShadowStyle(ShadowStyle.card.highlighted)
        
        static let disabled = normal.withShadowStyle(ShadowStyle.card.disabled)
    }
    
    struct button {
        static let normal = LayerStyle(opacity: 1,
                                       cornerRadius: Constant.buttonRadiusCorner,
                                       backgroundColor: currentColorTheme.component.callToAction.cgColor)
        
        static let highlighted = normal.withBackgroundColor(currentColorTheme.component.callToActionHighlighted.cgColor)
        
        static let disabled = normal.withBackgroundColor(currentColorTheme.component.callToActionDisabled.cgColor)
    }
    
    struct outlinedButton {
        static let normal = LayerStyle(cornerRadius: 0,
                                       borderWidth: Constant.buttonOutlinedBorderWidth,
                                       borderColor: currentColorTheme.component.callToAction.cgColor)
        
        static let highlighted = normal.withOpacity(Constant.buttonOutlinedOpacity)
        
        static let disabled = normal.withBorderColor(currentColorTheme.component.callToActionDisabled.cgColor)
    }
}

extension ShadowStyle {
    
    static let noShadow = ShadowStyle(shadowOpacity: 0, shadowRadius: 0, shadowOffset: .zero, shadowColor: currentColorTheme.component.shadow.cgColor)
    
    struct card {
        static let normal = ShadowStyle(shadowOpacity: 0.12,
                                        shadowRadius: 10,
                                        shadowOffset: .init(width: 0, height: 5),
                                        shadowColor: currentColorTheme.component.shadow.cgColor)
        
        static let highlighted = ShadowStyle(shadowOpacity: 0.10,
                                             shadowRadius: 2,
                                             shadowOffset: .init(width: 0, height: 2),
                                             shadowColor: currentColorTheme.component.shadow.cgColor)
        
        static let disabled = ShadowStyle(shadowOpacity: 0.08,
                                          shadowRadius: 1,
                                          shadowOffset: .init(width: 0, height: 1),
                                          shadowColor: currentColorTheme.component.shadow.cgColor)
    }
}
