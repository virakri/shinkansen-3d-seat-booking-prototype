//
//  HitTestFloorNode.swift
//  Shinkansen Tickets Booking Prototype
//
//  Created by Virakri Jinangkul on 6/7/19.
//  Copyright © 2019 Virakri Jinangkul. All rights reserved.
//

import SceneKit

class HitTestFloorNode: SCNNode {
    
    override init() {
        super.init()
        setupNode()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupNode() {
        let hitTestFloor = SCNFloor()
        hitTestFloor.reflectivity = 0
        hitTestFloor.firstMaterial?.transparency = 0
        geometry = hitTestFloor
        position.y = 1.3
        categoryBitMask = 1 << 1
    }
}
