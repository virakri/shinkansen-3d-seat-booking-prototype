//
//  Theme.swift
//  Shinkansen Tickets Booking Prototype
//
//  Created by Virakri Jinangkul on 5/28/19.
//  Copyright © 2019 Virakri Jinangkul. All rights reserved.
//

import UIKit

var currentColorTheme: ColorTheme = ColorTheme(rawValue: UserDefaults.standard.integer(forKey: "colorTheme")) ?? .light {
    didSet {
        if currentColorTheme != oldValue {
            UserDefaults.standard.set(currentColorTheme.rawValue, forKey: "colorTheme")
            NotificationCenter.default.post(name: .didColorThemeChange, object: nil)
        }
    }
}

internal enum ColorTheme: Int {
    case light, dark
    
    var componentColor: UIColor.Component {
        switch self {
        case .light:
            return UIColor().lightModeComponent
        case .dark:
            return UIColor().darkModeComponent
        }
    }
    
    var seatClassColor: UIColor.SeatClass {
        switch self {
        case .light:
            return UIColor.lightModeSeatClass
        case .dark:
            return UIColor.darkModeSeatClass
        }
    }
    
    var statusBarStyle: UIStatusBarStyle {
        switch self {
        case .light:
            return .default
        case .dark:
            return .lightContent
        }
    }
}
