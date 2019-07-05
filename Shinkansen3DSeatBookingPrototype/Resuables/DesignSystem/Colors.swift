//
//  Colors.swift
//  Shinkansen 3D Seat Booking Prototype
//
//  Created by Virakri Jinangkul on 5/14/19.
//  Copyright © 2019 Virakri Jinangkul. All rights reserved.
//

import UIKit

extension UIColor {
    
    struct accent {
        var main: UIColor {
            return UIAccessibility.isDarkerSystemColorsEnabled ? #colorLiteral(red: 0, green: 0.2784313725, blue: 0.1254901961, alpha: 1) : #colorLiteral(red: 0, green: 0.5450980392, blue: 0.2470588235, alpha: 1)
        }
        var dark: UIColor {
            return UIAccessibility.isDarkerSystemColorsEnabled ? #colorLiteral(red: 0, green: 0.2, blue: 0.09064748201, alpha: 1) : #colorLiteral(red: 0.02745098039, green: 0.4, blue: 0.1960784314, alpha: 1)
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
    
    struct miscellaneous {
        static let darkRed = #colorLiteral(red: 0.5333333333, green: 0.1529411765, blue: 0.262745098, alpha: 1)
        static let red = #colorLiteral(red: 0.7960784314, green: 0.2274509804, blue: 0.3921568627, alpha: 1)
        static let lightRed = #colorLiteral(red: 0.8666666667, green: 0.4352941176, blue: 0.5764705882, alpha: 1)
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
        
        var errorBackground: UIColor
    }
    
    struct SeatClassColor {
        var granClass: UIColor
        var green: UIColor
        var ordinary: UIColor
    }
    
    var lightModeSeatClass: SeatClassColor {
        let isDarkerColorEnabled = UIAccessibility.isDarkerSystemColorsEnabled
        return SeatClassColor(
            granClass: isDarkerColorEnabled ? #colorLiteral(red: 0.4235294118, green: 0.3568627451, blue: 0, alpha: 1) : #colorLiteral(red: 0.7333333333, green: 0.6196078431, blue: 0, alpha: 1),
            green:     isDarkerColorEnabled ? #colorLiteral(red: 0.2588235294, green: 0.4980392157, blue: 0, alpha: 1) : #colorLiteral(red: 0.4941176471, green: 0.8274509804, blue: 0.1294117647, alpha: 1),
            ordinary:  isDarkerColorEnabled ? #colorLiteral(red: 0, green: 0.3333333333, blue: 0.1529411765, alpha: 1) : #colorLiteral(red: 0, green: 0.5450980392, blue: 0.2470588235, alpha: 1))
    }
    
    static let darkModeSeatClass: SeatClassColor =
        SeatClassColor(granClass: #colorLiteral(red: 0.8745098039, green: 0.831372549, blue: 0.5803921569, alpha: 1),
                       green:     #colorLiteral(red: 0.7450980392, green: 0.9450980392, blue: 0.5254901961, alpha: 1),
                       ordinary:  #colorLiteral(red: 0.6862745098, green: 0.9098039216, blue: 0.7882352941, alpha: 1))
    
    //
    var lightModeComponent: Component {
        return Component(
            background:                basic.offWhite,
            cardBackground:            basic.white,
            cardDisabledBackground:    basic.white,
            primaryText:               basic.black,
            secondaryText:             basic().gray,
            onCardPrimaryText:         basic.black,
            onCardSecondaryText:       basic().gray,
            shadow:                    basic.black,
            callToAction:              accent().main,
            callToActionHighlighted:   accent().dark,
            callToActionDisabled:      basic().gray,
            contentOnCallToAction:     basic.white,
            errorBackground:           miscellaneous.lightRed
        )
    }
    
    var darkModeComponent: Component {
        return Component(
            background:                basic.offBlack,
            cardBackground:            basic.darkGray,
            cardDisabledBackground:    basic.slightlyBlack,
            primaryText:               basic.white,
            secondaryText:             basic().gray,
            onCardPrimaryText:         basic.black,
            onCardSecondaryText:       basic().gray,
            shadow:                    basic.black,
            callToAction:              basic.white,
            callToActionHighlighted:   basic.white
                .withAlphaComponent(DesignSystem.alpha.highlighted),
            callToActionDisabled:      basic().gray,
            contentOnCallToAction:     basic.offBlack,
            errorBackground:           miscellaneous.red
        )
    }
}
