//
//  TextStyle.swift
//  Shinkansen Tickets Booking Prototype
//
//  Created by Virakri Jinangkul on 5/14/19.
//  Copyright © 2019 Virakri Jinangkul. All rights reserved.
//

import UIKit
import Kumi

extension TextStyle {
    static let largeTitle = TextStyle(font:
        UIFontMetrics(forTextStyle: .largeTitle).scaledFont(for:
            UIFont.systemFont(ofSize: 34,
                              weight: UIAccessibility.isBoldTextEnabled ? .medium : .light), maximumPointSize: 34))
    static let headline = TextStyle(font:
        UIFontMetrics(forTextStyle: .subheadline).scaledFont(for:
            UIFont.systemFont(ofSize: 16,
                              weight: UIAccessibility.isBoldTextEnabled ? .medium : .regular), maximumPointSize: 20))
    static let subheadline = TextStyle(font:
        UIFontMetrics(forTextStyle: .subheadline).scaledFont(for:
            UIFont.systemFont(ofSize: 16,
                              weight: UIAccessibility.isBoldTextEnabled ? .medium : .regular), maximumPointSize: 20))
    static let body = TextStyle(font:
        UIFontMetrics(forTextStyle: .body).scaledFont(for:
            UIFont.systemFont(ofSize: 18,
                              weight: UIAccessibility.isBoldTextEnabled ? .medium : .regular), maximumPointSize: 20),
                                lineSpacing: 4)
    static let button = TextStyle(font:
        UIFontMetrics(forTextStyle: .callout).scaledFont(for:
            UIFont.systemFont(ofSize: 18,
                              weight: UIAccessibility.isBoldTextEnabled ? .medium : .regular), maximumPointSize: 20))
    static let outlinedButton = TextStyle(font:
        UIFontMetrics(forTextStyle: .callout).scaledFont(for:
            UIFont.systemFont(ofSize: 16,
                              weight: UIAccessibility.isBoldTextEnabled ? .semibold : .semibold), maximumPointSize: 20))
    static let footnote = TextStyle(font:
        UIFontMetrics(forTextStyle: .footnote).scaledFont(for:
            UIFont.systemFont(ofSize: 11,
                              weight: UIAccessibility.isBoldTextEnabled ? .heavy : .medium), maximumPointSize: 20),
                                    textTransform: .uppercased)
    static let caption1 = TextStyle(font:
        UIFontMetrics(forTextStyle: .caption1).scaledFont(for:
            UIFont.systemFont(ofSize: 13,
                              weight: UIAccessibility.isBoldTextEnabled ? .medium : .regular), maximumPointSize: 20))
    static let caption2 = TextStyle(font:
        UIFontMetrics(forTextStyle: .caption2).scaledFont(for:
            UIFont.systemFont(ofSize: 10,
                              weight: UIAccessibility.isBoldTextEnabled ? .heavy : .medium), maximumPointSize: 20))
}
