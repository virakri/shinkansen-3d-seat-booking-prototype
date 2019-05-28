//
//  Colors.swift
//  Shinkansen Tickets Booking Prototype
//
//  Created by Virakri Jinangkul on 5/14/19.
//  Copyright © 2019 Virakri Jinangkul. All rights reserved.
//

import UIKit

internal enum colorTheme {
    case light, dark
    
    var component: UIColor.Component {
        switch self {
        case .light:
            return UIColor.lightMode
        case .dark:
            return UIColor.darkMode
        }
    }
}

extension UIColor {
    
    struct accent {
        static let main = #colorLiteral(red: 0, green: 0.5450980392, blue: 0.2470588235, alpha: 1)
        static let dark = #colorLiteral(red: 0.02658655568, green: 0.400528169, blue: 0.196070884, alpha: 1)
        static let light = #colorLiteral(red: 0.2928808364, green: 0.7157515405, blue: 0.4845416591, alpha: 1)
    }
    
    struct basic {
        static let black = #colorLiteral(red: 0.05098039216, green: 0.05098039216, blue: 0.05098039216, alpha: 1)
        static let offBlack = #colorLiteral(red: 0.1294117647, green: 0.1294117647, blue: 0.1294117647, alpha: 1)
        static let gray = #colorLiteral(red: 0.5647058824, green: 0.5647058824, blue: 0.5843137255, alpha: 1)
        static let offWhite = #colorLiteral(red: 0.9803921569, green: 0.9803921569, blue: 0.9803921569, alpha: 1)
        static let white = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
    
    struct Component {
        var background: UIColor
        var cardBackground: UIColor
        var primaryText: UIColor
        var secondaryText: UIColor
        
        var onCardPrimaryText: UIColor
        var onCardSecondaryText: UIColor
        
        var shadow: UIColor
        
        var callToAction: UIColor
        var callToActionHighlighted: UIColor
        var callToActionDisabled: UIColor
    }
    
    //
    static let lightMode: Component = Component(background: UIColor.basic.offWhite,
                                                cardBackground: UIColor.basic.white,
                                                primaryText: UIColor.basic.black,
                                                secondaryText: UIColor.basic.gray,
                                                onCardPrimaryText: UIColor.basic.black,
                                                onCardSecondaryText: UIColor.basic.gray,
                                                shadow: UIColor.basic.black,
                                                callToAction: UIColor.accent.main,
                                                callToActionHighlighted: UIColor.accent.dark,
                                                callToActionDisabled: UIColor.basic.gray)
    
    static let darkMode: Component = Component(background: UIColor.basic.offBlack,
                                                cardBackground: UIColor.basic.white,
                                                primaryText: UIColor.basic.white,
                                                secondaryText: UIColor.basic.gray,
                                                onCardPrimaryText: UIColor.basic.black,
                                                onCardSecondaryText: UIColor.basic.gray,
                                                shadow: UIColor.basic.black,
                                                callToAction: UIColor.basic.white,
                                                callToActionHighlighted: UIColor.basic.gray,
                                                callToActionDisabled: UIColor.basic.gray)
    
}
