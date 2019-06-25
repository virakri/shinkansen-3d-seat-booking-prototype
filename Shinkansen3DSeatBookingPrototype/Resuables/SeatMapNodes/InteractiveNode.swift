//
//  ReservableNode.swift
//  Shinkansen 3D Seat Booking Prototype
//
//  Created by Nattawut Singhchai on 6/7/19.
//  Copyright © 2019 Virakri Jinangkul. All rights reserved.
//

import SceneKit

class InteractiveNode: StaticNode {
    
    static let defaultBitMask = 1 << 2
    
    var reservableEntity: ReservableEntity?
    
    var isHighlighted: Bool = false
    
    var isSelected: Bool = false
    
    weak var touch: UITouch?
    
    override init() {
        super.init()
    }
    
    required init(node: SCNNode) {
        super.init(node: node)
        categoryBitMask = InteractiveNode.defaultBitMask
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
