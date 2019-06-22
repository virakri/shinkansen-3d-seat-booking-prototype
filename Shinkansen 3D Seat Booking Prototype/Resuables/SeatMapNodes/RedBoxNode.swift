//
//  RedBoxNode.swift
//  Shinkansen 3D Seat Booking Prototype
//
//  Created by Nattawut Singhchai on 14/6/2019 .
//  Copyright © 2019 Virakri Jinangkul. All rights reserved.
//

import SceneKit

class RedBoxNode: ReservableNode {
    
    /// Current node's entity information
    override var reservableEntity: ReservableEntity? {
        didSet {
            super.reservableEntity = reservableEntity
            if let reservableEntity = reservableEntity {
                updateReservableEntity(reservableEntity: reservableEntity)
            }
        }
    }
    
    init() {
        let node = SCNNode()
        node.geometry = SCNBox(width: 0.5, height: 0.5, length: 0.5, chamferRadius: 0.1)
        node.geometry?.firstMaterial?.diffuse.contents = UIColor.red
        super.init(node: node, modelData: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    required init(node: SCNNode, modelData: ModelData?) {
        fatalError("init(node:modelData:) has not been implemented")
    }
    
    /// Function to update transform from `reservableEntity`
    /// - Parameter reservableEntity: Target tranfrom data
    private func updateReservableEntity(reservableEntity: ReservableEntity) {
        position = reservableEntity.transformedModelEntity.position
        eulerAngles = reservableEntity.transformedModelEntity.rotation
    }
}
