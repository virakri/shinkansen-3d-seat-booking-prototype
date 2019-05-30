//
//  Constant.swift
//  Shinkansen Tickets Booking Prototype
//
//  Created by Virakri Jinangkul on 5/29/19.
//  Copyright © 2019 Virakri Jinangkul. All rights reserved.
//

import UIKit

struct Constant {
    
    static let multiplier: CGFloat = UIFontMetrics(forTextStyle: .body).scaledFont(for: .systemFont(ofSize: 1)).pointSize
    
    static let buttonEdgeInset: UIEdgeInsets = UIEdgeInsets(top: multiplier * 18,
                                                            left: multiplier * 18,
                                                            bottom: multiplier * 18,
                                                            right: multiplier * 18)
    
    static let buttonRadiusCorner: CGFloat = multiplier * 8
    
    static let buttonOutlinedEdgeInset: UIEdgeInsets = UIEdgeInsets(top: multiplier * 8,
                                                                    left: multiplier * 14,
                                                                    bottom: multiplier * 8,
                                                                    right: multiplier * 14)
    
    static let buttonOutlinedBorderWidth: CGFloat = 1
    static let buttonOutlinedOpacity: Float = 0.54
    
    static let buttonTextEdgeInset: UIEdgeInsets = UIEdgeInsets(top: multiplier * 14,
                                                                left: multiplier * 14,
                                                                bottom: multiplier * 14,
                                                                right: multiplier * 14)
    
    static let cardRadiusCorner: CGFloat = multiplier * 8
    static let largeCardRadiusCorner: CGFloat = multiplier * 20
    
    static let cardLayoutMarginInset: NSDirectionalEdgeInsets = .init(vertical: 12, horizontal: 16)
    static let largeCardLayoutMarginInset: NSDirectionalEdgeInsets = .init(vertical: 20, horizontal: 16)
    
    static let gutterSpacing: CGFloat = multiplier * 16
    
}
