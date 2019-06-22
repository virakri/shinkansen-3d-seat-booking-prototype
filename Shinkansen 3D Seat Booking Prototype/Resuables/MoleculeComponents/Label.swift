//
//  Label.swift
//  Shinkansen Tickets Booking Prototype
//
//  Created by Virakri Jinangkul on 5/28/19.
//  Copyright © 2019 Virakri Jinangkul. All rights reserved.
//

import UIKit
import Kumi

/// A view that is subclassed from UILabel which includes `textStyle` property for containing text style. 
class Label: UILabel {
    
    override var text: String? {
        didSet {
            textStyleUpdated()
        }
    }
    
    var textStyle: TextStyle? {
        didSet {
            textStyleUpdated()
        }
    }
    
    internal func textStyleUpdated() {
        if let text = text, let textStyle = textStyle {
            setMarkdownText(text, using: textStyle.with(newTextColor: textColor, newTextAlignment: textAlignment))
        }
    }
}
