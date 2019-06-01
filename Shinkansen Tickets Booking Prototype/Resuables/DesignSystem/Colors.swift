//
//  Colors.swift
//  Shinkansen Tickets Booking Prototype
//
//  Created by Virakri Jinangkul on 5/14/19.
//  Copyright © 2019 Virakri Jinangkul. All rights reserved.
//

import UIKit

//internal struct ColorTheme {
//    var light: UIColor
//    var dark: UIColor
//}

extension UIColor {
    
    struct accent {
        static let main = UIAccessibility.isDarkerSystemColorsEnabled ? #colorLiteral(red: 0, green: 0.28, blue: 0.1269064748, alpha: 1) : #colorLiteral(red: 0, green: 0.5450980392, blue: 0.2470588235, alpha: 1)
        static let dark = UIAccessibility.isDarkerSystemColorsEnabled ? #colorLiteral(red: 0, green: 0.2, blue: 0.09064748201, alpha: 1) : #colorLiteral(red: 0.02658655568, green: 0.400528169, blue: 0.196070884, alpha: 1)
        static let light = UIAccessibility.isDarkerSystemColorsEnabled ? #colorLiteral(red: 0, green: 0.35, blue: 0.1586330935, alpha: 1) : #colorLiteral(red: 0.2928808364, green: 0.7157515405, blue: 0.4845416591, alpha: 1)
    }
    
    struct basic {
        static let black = #colorLiteral(red: 0.05098039216, green: 0.05098039216, blue: 0.05098039216, alpha: 1)
        static let offBlack = #colorLiteral(red: 0.1294117647, green: 0.1294117647, blue: 0.1294117647, alpha: 1)
        static let darkGray = #colorLiteral(red: 0.18, green: 0.18, blue: 0.18, alpha: 1)
        static let gray = UIAccessibility.isDarkerSystemColorsEnabled ? #colorLiteral(red: 0.18, green: 0.18, blue: 0.18, alpha: 1) : #colorLiteral(red: 0.5647058824, green: 0.5647058824, blue: 0.5843137255, alpha: 1)
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
        
        var contentOnCallToAction: UIColor
    }
    
    struct SeatClass {
        var granClass: UIColor
        var green: UIColor
        var ordinary: UIColor
    }
    
    static let lightModeSeatClass: SeatClass = SeatClass(granClass: UIAccessibility.isDarkerSystemColorsEnabled ? #colorLiteral(red: 0.4235294118, green: 0.3568627451, blue: 0, alpha: 1) : #colorLiteral(red: 0.7333333333, green: 0.6196078431, blue: 0, alpha: 1),
                                                         green:
        UIAccessibility.isDarkerSystemColorsEnabled ? #colorLiteral(red: 0.2588235294, green: 0.4980392157, blue: 0, alpha: 1) : #colorLiteral(red: 0.4941176471, green: 0.8274509804, blue: 0.1294117647, alpha: 1),
                                                         ordinary:
        UIAccessibility.isDarkerSystemColorsEnabled ? #colorLiteral(red: 0, green: 0.3333333333, blue: 0.1529411765, alpha: 1) : #colorLiteral(red: 0, green: 0.5450980392, blue: 0.2470588235, alpha: 1))
    
    static let darkModeSeatClass: SeatClass = SeatClass(granClass:#colorLiteral(red: 0.8745098039, green: 0.831372549, blue: 0.5803921569, alpha: 1),
                                                         green: #colorLiteral(red: 0.7450980392, green: 0.9450980392, blue: 0.5254901961, alpha: 1),
                                                         ordinary:#colorLiteral(red: 0.6862745098, green: 0.9098039216, blue: 0.7882352941, alpha: 1))
    
    //
    static let lightModeComponent: Component = Component(background: UIColor.basic.offWhite,
                                                cardBackground: UIColor.basic.white,
                                                primaryText: UIColor.basic.black,
                                                secondaryText: UIColor.basic.gray,
                                                onCardPrimaryText: UIColor.basic.black,
                                                onCardSecondaryText: UIColor.basic.gray,
                                                shadow: UIColor.basic.black,
                                                callToAction: UIColor.accent.main,
                                                callToActionHighlighted: UIColor.accent.dark,
                                                callToActionDisabled: UIColor.basic.gray,
                                                contentOnCallToAction: UIColor.basic.white)
    
    static let darkModeComponent: Component = Component(background: UIColor.basic.offBlack,
                                                cardBackground: UIColor.basic.darkGray,
                                                primaryText: UIColor.basic.white,
                                                secondaryText: UIColor.basic.gray,
                                                onCardPrimaryText: UIColor.basic.black,
                                                onCardSecondaryText: UIColor.basic.gray,
                                                shadow: UIColor.basic.black,
                                                callToAction: UIColor.basic.white,
                                                callToActionHighlighted: UIColor.basic.white.withAlphaComponent(0.54),
                                                callToActionDisabled: UIColor.basic.gray,
                                                contentOnCallToAction: UIColor.accent.main)
    
}
