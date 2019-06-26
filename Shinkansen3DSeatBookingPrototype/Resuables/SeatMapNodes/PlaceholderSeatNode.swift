//
//  RedBoxNode.swift
//  Shinkansen 3D Seat Booking Prototype
//
//  Created by Nattawut Singhchai on 14/6/2019 .
//  Copyright © 2019 Virakri Jinangkul. All rights reserved.
//

import SceneKit

class PlaceholderSeatNode: SeatNode {
    
     init() {
        let node = SCNNode()
        node.geometry = SCNBox(width: 0.5, height: 0.5, length: 0.5, chamferRadius: 0.1)
        node.geometry?.firstMaterial?.diffuse.contents = UIColor.red
        super.init(node: node)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    required init(node: SCNNode) {
        fatalError("init(node:modelData:) has not been implemented")
    }
}
