//
//  ReservableNode.swift
//  Shinkansen Tickets Booking Prototype
//
//  Created by Nattawut Singhchai on 6/7/19.
//  Copyright © 2019 Virakri Jinangkul. All rights reserved.
//

import SceneKit

class ReservableNode: SCNNode {
    let reservableEntity: ReservableEntity
    
    init(reservableEntity: ReservableEntity) {
        self.reservableEntity = reservableEntity
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
