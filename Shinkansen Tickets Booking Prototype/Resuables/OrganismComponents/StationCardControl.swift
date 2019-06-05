//
//  StationCardControl.swift
//  Shinkansen Tickets Booking Prototype
//
//  Created by Virakri Jinangkul on 6/2/19.
//  Copyright © 2019 Virakri Jinangkul. All rights reserved.
//

import UIKit
import Kumi

class StationCardControl: CardControl {
    
    var basedHeight: CGFloat = DesignSystem.isNarrowScreen ? 64 : 72 {
        didSet {
//            setupTheme()
        }
    }
    
    init() {
        super.init(type: .regular)
        
        // temp
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: basedHeight).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
