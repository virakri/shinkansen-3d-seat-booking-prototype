//
//  Label.swift
//  Shinkansen Tickets Booking Prototype
//
//  Created by Virakri Jinangkul on 5/28/19.
//  Copyright © 2019 Virakri Jinangkul. All rights reserved.
//

import UIKit
import Kumi

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
            setText(text, using: textStyle)
        }
    }
}
