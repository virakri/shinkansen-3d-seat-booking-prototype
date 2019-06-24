//
//  ReservableNode.swift
//  Shinkansen 3D Seat Booking Prototype
//
//  Created by Nattawut Singhchai on 6/7/19.
//  Copyright © 2019 Virakri Jinangkul. All rights reserved.
//

import SceneKit

class ReservableNode: SCNNode, InteractibleNode {
    
    static let defaultBitMask = 1 << 2
    
    var reservableEntity: ReservableEntity?
    
    var modelData: ModelData?
    
    var isHighlighted: Bool = false
    
    var isSelected: Bool = false
    
    var isEnabled: Bool = true
    
    weak var touch: UITouch?
    
    required init(node: SCNNode) {
        super.init()
        self.addChildNode(node)
        categoryBitMask = ReservableNode.defaultBitMask
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
