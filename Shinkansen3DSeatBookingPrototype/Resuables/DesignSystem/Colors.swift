//
//  Colors.swift
//  Shinkansen 3D Seat Booking Prototype
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
        var main: UIColor {
            return UIAccessibility.isDarkerSystemColorsEnabled ? #colorLiteral(red: 0, green: 0.2784313725, blue: 0.1254901961, alpha: 1) : #colorLiteral(red: 0, green: 0.5450980392, blue: 0.2470588235, alpha: 1)
        }
        var dark: UIColor {
            return UIAccessibility.isDarkerSystemColorsEnabled ? #colorLiteral(red: 0, green: 0.2, blue: 0.09064748201, alpha: 1) : #colorLiteral(red: 0.02658655568, green: 0.400528169, blue: 0.196070884, alpha: 1)
        }
        var light: UIColor {
            return UIAccessibility.isDarkerSystemColorsEnabled ? #colorLiteral(red: 0, green: 0.35, blue: 0.1586330935, alpha: 1) : #colorLiteral(red: 0.2928808364, green: 0.7157515405, blue: 0.4845416591, alpha: 1)
        }
    }
    
    struct basic {
        static let black = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        static let offBlack = #colorLiteral(red: 0.13, green: 0.13, blue: 0.13, alpha: 1)
        static let slightlyBlack = #colorLiteral(red: 0.1411764706, green: 0.1411764706, blue: 0.1411764706, alpha: 1)
        static let darkGray = #colorLiteral(red: 0.1803921569, green: 0.1803921569, blue: 0.1803921569, alpha: 1)
        static let slightlyDarkGray = #colorLiteral(red: 0.2365458608, green: 0.2365458608, blue: 0.2365458608, alpha: 1)
        var gray: UIColor {
            return UIAccessibility.isDarkerSystemColorsEnabled ? #colorLiteral(red: 0.18, green: 0.18, blue: 0.18, alpha: 1) : #colorLiteral(red: 0.5647058824, green: 0.5647058824, blue: 0.5843137255, alpha: 1)
        }
        static let offWhite = #colorLiteral(red: 0.9803921569, green: 0.9803921569, blue: 0.9803921569, alpha: 1)
        static let white = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
    
    struct Component {
        var background: UIColor
        var cardBackground: UIColor
        var cardDisabledBackground: UIColor
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
    
    struct _SeatClass {
        var granClass: UIColor
        var green: UIColor
        var ordinary: UIColor
    }
    
    static let lightModeSeatClass: _SeatClass = _SeatClass(granClass: UIAccessibility.isDarkerSystemColorsEnabled ? #colorLiteral(red: 0.4235294118, green: 0.3568627451, blue: 0, alpha: 1) : #colorLiteral(red: 0.7333333333, green: 0.6196078431, blue: 0, alpha: 1),
                                                         green:
        UIAccessibility.isDarkerSystemColorsEnabled ? #colorLiteral(red: 0.2588235294, green: 0.4980392157, blue: 0, alpha: 1) : #colorLiteral(red: 0.4941176471, green: 0.8274509804, blue: 0.1294117647, alpha: 1),
                                                         ordinary:
        UIAccessibility.isDarkerSystemColorsEnabled ? #colorLiteral(red: 0, green: 0.3333333333, blue: 0.1529411765, alpha: 1) : #colorLiteral(red: 0, green: 0.5450980392, blue: 0.2470588235, alpha: 1))
    
    static let darkModeSeatClass: _SeatClass = _SeatClass(granClass:#colorLiteral(red: 0.8745098039, green: 0.831372549, blue: 0.5803921569, alpha: 1),
                                                         green: #colorLiteral(red: 0.7450980392, green: 0.9450980392, blue: 0.5254901961, alpha: 1),
                                                         ordinary:#colorLiteral(red: 0.6862745098, green: 0.9098039216, blue: 0.7882352941, alpha: 1))
    
    //
    var lightModeComponent: Component {
        return Component(background: UIColor.basic.offWhite,
                         cardBackground: UIColor.basic.white,
                         cardDisabledBackground: UIColor.basic.white,
                         primaryText: UIColor.basic.black,
                         secondaryText: UIColor.basic().gray,
                         onCardPrimaryText: UIColor.basic.black,
                         onCardSecondaryText: UIColor.basic().gray,
                         shadow: UIColor.basic.black,
                         callToAction: UIColor.accent().main,
                         callToActionHighlighted: UIColor.accent().dark,
                         callToActionDisabled: UIColor.basic().gray,
                         contentOnCallToAction: UIColor.basic.white) }
    
    var darkModeComponent: Component {
        return Component(background: UIColor.basic.offBlack,
                         cardBackground: UIColor.basic.darkGray,
                         cardDisabledBackground: UIColor.basic.slightlyBlack,
                         primaryText: UIColor.basic.white,
                         secondaryText: UIColor.basic().gray,
                         onCardPrimaryText: UIColor.basic.black,
                         onCardSecondaryText: UIColor.basic().gray,
                         shadow: UIColor.basic.black,
                         callToAction: UIColor.basic.white,
                         callToActionHighlighted: UIColor.basic.white
                            .withAlphaComponent(DesignSystem.alpha.highlighted),
                         callToActionDisabled: UIColor.basic().gray,
                         contentOnCallToAction: UIColor.basic.offBlack)
    }
}
