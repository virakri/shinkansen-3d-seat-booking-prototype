//
//  LayerStyle.swift
//  Shinkansen Tickets Booking Prototype
//
//  Created by Virakri Jinangkul on 5/14/19.
//  Copyright © 2019 Virakri Jinangkul. All rights reserved.
//

import UIKit
import Kumi

typealias shadowStyle = DesignSystem.shadowStyle
typealias layerStyle = DesignSystem.layerStyle

extension DesignSystem {
    class layerStyle {
        
        static let none = LayerStyle(opacity: 0)
        
        class card {
            class func normal() -> LayerStyle {
                return LayerStyle(opacity: 1,
                                  cornerRadius: DesignSystem.radiusCorner.card(),
                                  backgroundColor: currentColorTheme.componentColor.cardBackground.cgColor,
                                  shadowStyle: shadowStyle.card.normal()
                )
            }
            
            class func highlighted() -> LayerStyle {
                return normal().withShadowStyle(shadowStyle.card.highlighted())
            }
            
            class func disabled() -> LayerStyle {
                return normal().withShadowStyle(shadowStyle.card.disabled())
            }
        }
        
        class largeCard {
            class func normal() -> LayerStyle {
                return LayerStyle(opacity: 1,
                                  cornerRadius: DesignSystem.radiusCorner.largeCard(),
                                  backgroundColor: currentColorTheme.componentColor.cardBackground.cgColor,
                    shadowStyle: shadowStyle.card.normal()
                )
            }
            
            class func highlighted() -> LayerStyle {
                return normal().withShadowStyle(shadowStyle.card.highlighted())
            }
            
            class func disabled() -> LayerStyle {
                return normal().withShadowStyle(shadowStyle.card.disabled())
            }
        }
        
        class button {
            class func normal() -> LayerStyle {
                return LayerStyle(opacity: 1,
                                  cornerRadius: DesignSystem.radiusCorner.button(),
                                  backgroundColor: currentColorTheme.componentColor.callToAction.cgColor)
            }
            
            class func highlighted() -> LayerStyle {
                return normal().withBackgroundColor(currentColorTheme.componentColor.callToActionHighlighted.cgColor)
            }
            
            class func disabled() -> LayerStyle {
                return normal().withBackgroundColor(currentColorTheme.componentColor.callToActionDisabled.cgColor)
            }
        }
 
        class outlinedButton {
            class func normal() -> LayerStyle {
                return LayerStyle(cornerRadius: 0,
                                  borderWidth: DesignSystem.borderWidth.outlinedButton,
                                  borderColor: currentColorTheme.componentColor.callToAction.cgColor)
            }
            
            class func highlighted() -> LayerStyle {
                return normal().withOpacity(DesignSystem.opacity.highlighted)
            }
            
            class func disabled() -> LayerStyle {
                return normal().withBorderColor(currentColorTheme.componentColor.callToActionDisabled.cgColor)
            }
        }
    }
    
    class shadowStyle {
        
        class func noShadow() -> ShadowStyle {
            return ShadowStyle(shadowOpacity: 0, shadowRadius: 0, shadowOffset: .zero, shadowColor: currentColorTheme.componentColor.shadow.cgColor)
        }
        
        class card {
            class func normal() -> ShadowStyle {
                return ShadowStyle(shadowOpacity: 0.12,
                                   shadowRadius: 10,
                                   shadowOffset: .init(width: 0, height: 5),
                                   shadowColor: currentColorTheme.componentColor.shadow.cgColor)
            }
            
            class func highlighted() -> ShadowStyle {
                return ShadowStyle(shadowOpacity: 0.10,
                                   shadowRadius: 2,
                                   shadowOffset: .init(width: 0, height: 2),
                                   shadowColor: currentColorTheme.componentColor.shadow.cgColor)
            }
            
            class func disabled() -> ShadowStyle {
                return ShadowStyle(shadowOpacity: 0.08,
                                   shadowRadius: 1,
                                   shadowOffset: .init(width: 0, height: 1),
                                   shadowColor: currentColorTheme.componentColor.shadow.cgColor)
            }
        }
    }
}
