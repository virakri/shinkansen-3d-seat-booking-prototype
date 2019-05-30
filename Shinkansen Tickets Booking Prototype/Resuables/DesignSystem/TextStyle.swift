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
    static let headline = TextStyle(font:
        UIFontMetrics(forTextStyle: .headline).scaledFont(for:
            UIFont.systemFont(ofSize: 34,
                              weight: UIAccessibility.isBoldTextEnabled ? .bold : .light)))
    static let subheadline = TextStyle(font:
        UIFontMetrics(forTextStyle: .subheadline).scaledFont(for:
            UIFont.systemFont(ofSize: 11,
                              weight: UIAccessibility.isBoldTextEnabled ? .heavy : .medium)),
                                       textTransform: .uppercased)
    static let body = TextStyle(font:
        UIFontMetrics(forTextStyle: .body).scaledFont(for:
            UIFont.systemFont(ofSize: 18,
                              weight: UIAccessibility.isBoldTextEnabled ? .bold : .regular)),
                                lineSpacing: 4)
    static let button = TextStyle(font:
        UIFontMetrics(forTextStyle: .callout).scaledFont(for:
            UIFont.systemFont(ofSize: 18,
                              weight: UIAccessibility.isBoldTextEnabled ? .bold : .regular)))
    static let outlinedButton = TextStyle(font:
        UIFontMetrics(forTextStyle: .callout).scaledFont(for:
            UIFont.systemFont(ofSize: 16,
                              weight: UIAccessibility.isBoldTextEnabled ? .bold : .semibold)))
    static let caption1 = TextStyle(font:
        UIFontMetrics(forTextStyle: .caption1).scaledFont(for:
            UIFont.systemFont(ofSize: 13,
                              weight: UIAccessibility.isBoldTextEnabled ? .bold : .regular)))
    static let caption2 = TextStyle(font: UIFontMetrics(forTextStyle:
        .caption2).scaledFont(for:
            UIFont.systemFont(ofSize: 10,
                              weight: UIAccessibility.isBoldTextEnabled ? .heavy : .medium)))
}
