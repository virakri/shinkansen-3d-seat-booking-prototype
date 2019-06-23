//
//  TextStyle.swift
//  Shinkansen 3D Seat Booking Prototype
//
//  Created by Virakri Jinangkul on 5/14/19.
//  Copyright © 2019 Virakri Jinangkul. All rights reserved.
//

import UIKit
import Kumi

typealias textStyle = DesignSystem.textStyle

extension DesignSystem {
    
    class textStyle {
        
        class func largeTitle() -> TextStyle {
            let fontSize: CGFloat = DesignSystem.isNarrowScreen ? 28 : 34
            return TextStyle(font:
                UIFontMetrics(forTextStyle: .largeTitle).scaledFont(for:
                    UIFont.systemFont(ofSize: fontSize,
                                      weight: UIAccessibility.isBoldTextEnabled ? .medium : .light), maximumPointSize: fontSize))
        }
        
        class func title1() -> TextStyle {
            return TextStyle(font:
                UIFontMetrics(forTextStyle: .title1).scaledFont(for:
                    UIFont.systemFont(ofSize: 24,
                                      weight: UIAccessibility.isBoldTextEnabled ? .medium : .regular), maximumPointSize: 28))
        }
        
        class func headline() -> TextStyle {
            return TextStyle(font:
                UIFontMetrics(forTextStyle: .subheadline).scaledFont(for:
                    UIFont.systemFont(ofSize: 16,
                                      weight: UIAccessibility.isBoldTextEnabled ? .medium : .regular), maximumPointSize: 22))
        }
        
        class func subheadline() -> TextStyle {
            return TextStyle(font:
                UIFontMetrics(forTextStyle: .subheadline).scaledFont(for:
                    UIFont.systemFont(ofSize: 16,
                                      weight: UIAccessibility.isBoldTextEnabled ? .medium : .regular), maximumPointSize: 22))
        }
        
        class func body() -> TextStyle {
            return TextStyle(font:
                UIFontMetrics(forTextStyle: .body).scaledFont(for:
                    UIFont.systemFont(ofSize: 18,
                                      weight: UIAccessibility.isBoldTextEnabled ? .medium : .regular), maximumPointSize: 24),
                             lineSpacing: 4)
        }
        
        class func button() -> TextStyle {
            return TextStyle(font:
                UIFontMetrics(forTextStyle: .callout).scaledFont(for:
                    UIFont.systemFont(ofSize: 18,
                                      weight: UIAccessibility.isBoldTextEnabled ? .bold : .medium), maximumPointSize: 24))
        }
        
        class func outlinedButton() -> TextStyle {
            return TextStyle(font:
                UIFontMetrics(forTextStyle: .callout).scaledFont(for:
                    UIFont.systemFont(ofSize: 16,
                                      weight: UIAccessibility.isBoldTextEnabled ? .semibold : .semibold), maximumPointSize: 20))
        }
        
        class func footnote() -> TextStyle {
            return TextStyle(font:
                UIFontMetrics(forTextStyle: .footnote).scaledFont(for:
                    UIFont.systemFont(ofSize: 11,
                                      weight: UIAccessibility.isBoldTextEnabled ? .heavy : .medium), maximumPointSize: 16),
                             textTransform: .uppercased)
        }
        
        class func caption1() -> TextStyle {
            return TextStyle(font:
                UIFontMetrics(forTextStyle: .caption1).scaledFont(for:
                    UIFont.systemFont(ofSize: 13,
                                      weight: UIAccessibility.isBoldTextEnabled ? .medium : .regular), maximumPointSize: 18))
        }
        
        class func caption1Alt() -> TextStyle {
            return TextStyle(font:
                UIFontMetrics(forTextStyle: .caption1).scaledFont(for:
                    UIFont.systemFont(ofSize: 13,
                                      weight: UIAccessibility.isBoldTextEnabled ? .semibold : .medium), maximumPointSize: 18))
        }
        
        class func caption2() -> TextStyle {
            return TextStyle(font:
                UIFontMetrics(forTextStyle: .caption2).scaledFont(for:
                    UIFont.systemFont(ofSize: 10,
                                      weight: UIAccessibility.isBoldTextEnabled ? .heavy : .medium), maximumPointSize: 15))
        }
    }
}
