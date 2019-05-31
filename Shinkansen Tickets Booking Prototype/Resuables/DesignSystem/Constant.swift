//
//  Constant.swift
//  Shinkansen Tickets Booking Prototype
//
//  Created by Virakri Jinangkul on 5/29/19.
//  Copyright © 2019 Virakri Jinangkul. All rights reserved.
//

import UIKit

struct Constant {
    
    static let multiplier: CGFloat = UIFontMetrics(forTextStyle: .body).scaledFont(for: .systemFont(ofSize: 256)).pointSize / 256
    
    static let buttonEdgeInset: UIEdgeInsets = .init(top: (multiplier * 18).pixelRounded(),
                                                     left: (multiplier * 18).pixelRounded(),
                                                     bottom: (multiplier * 18).pixelRounded(),
                                                     right: (multiplier * 18).pixelRounded())
    
    static let buttonRadiusCorner: CGFloat = (multiplier * 8).pixelRounded()
    
    static let buttonOutlinedEdgeInset: UIEdgeInsets = .init(top: (multiplier * 8).pixelRounded(),
                                                             left: (multiplier * 20).pixelRounded(),
                                                             bottom: (multiplier * 8).pixelRounded(),
                                                             right: (multiplier * 20).pixelRounded())
    
    static let buttonOutlinedBorderWidth: CGFloat = 1
    static let buttonOutlinedOpacity: Float = 0.54
    
    static let buttonTextEdgeInset: UIEdgeInsets = .init(top: (multiplier * 14).pixelRounded(),
                                                         left: (multiplier * 14).pixelRounded(),
                                                         bottom: (multiplier * 14).pixelRounded(),
                                                         right: (multiplier * 14).pixelRounded())
    
    static let cardRadiusCorner: CGFloat = (multiplier * 8).pixelRounded()
    static let largeCardRadiusCorner: CGFloat = (multiplier * 20).pixelRounded()
    
    static let cardLayoutMarginInset: NSDirectionalEdgeInsets = .init(vertical: 12, horizontal: 16)
    static let largeCardLayoutMarginInset: NSDirectionalEdgeInsets = .init(vertical: 20, horizontal: 16)
    
    static let gutterSpacing: CGFloat = (multiplier * 16).pixelRounded()
    
}
