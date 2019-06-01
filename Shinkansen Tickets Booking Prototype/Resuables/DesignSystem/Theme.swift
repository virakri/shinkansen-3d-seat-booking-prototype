//
//  Theme.swift
//  Shinkansen Tickets Booking Prototype
//
//  Created by Virakri Jinangkul on 5/28/19.
//  Copyright © 2019 Virakri Jinangkul. All rights reserved.
//

import UIKit

var currentColorTheme: ColorTheme = UserDefaults.standard.object(forKey: "colorTheme") as? ColorTheme ?? .light {
    didSet {
        if currentColorTheme != oldValue {
            UserDefaults.standard.set(currentColorTheme, forKey: "colorTheme")
            NotificationCenter.default.post(name: .didColorThemeChange, object: nil)
        }
    }
}

internal enum ColorTheme {
    case light, dark
    
    var component: UIColor.Component {
        switch self {
        case .light:
            return UIColor.lightMode
        case .dark:
            return UIColor.darkMode
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
