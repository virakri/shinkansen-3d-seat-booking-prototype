//
//  ReservableNode.swift
//  Shinkansen Tickets Booking Prototype
//
//  Created by Nattawut Singhchai on 6/7/19.
//  Copyright © 2019 Virakri Jinangkul. All rights reserved.
//

import SceneKit

class ReservableNode: SCNNode {
    
    static let defaultBitMask = 1 << 2
    
    let reservableEntity: ReservableEntity
    
    var isHighlighted: Bool = false
    
    var isSelected: Bool = false
    
    var isEnabled: Bool = true
    
    init(reservableEntity: ReservableEntity) {
        self.reservableEntity = reservableEntity
        super.init()
        categoryBitMask = ReservableNode.defaultBitMask
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
