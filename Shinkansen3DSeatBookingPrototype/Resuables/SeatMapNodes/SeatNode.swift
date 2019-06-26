//
//  SeatNode.swift
//  Shinkansen3DSeatBookingPrototype
//
//  Created by Virakri Jinangkul on 6/26/19.
//  Copyright © 2019 Virakri Jinangkul. All rights reserved.
//

import SceneKit

class SeatNode: InteractiveNode {
    
    /// Current node's entity information
    var reservableEntity: ReservableEntity? {
        didSet {
            if let reservableEntity = reservableEntity {
                updateReservableEntity(reservableEntity: reservableEntity)
            }
        }
    }
    
    /// Function to update transform from `reservableEntity`
    /// - Parameter reservableEntity: Target tranfrom data
    private func updateReservableEntity(reservableEntity: ReservableEntity) {
        position = reservableEntity.transformedModelEntity.position
        eulerAngles = reservableEntity.transformedModelEntity.rotation
    }
}
