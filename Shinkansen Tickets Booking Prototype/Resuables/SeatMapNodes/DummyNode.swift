//
//  DummyNode.swift
//  Shinkansen Tickets Booking Prototype
//
//  Created by Virakri Jinangkul on 6/7/19.
//  Copyright © 2019 Virakri Jinangkul. All rights reserved.
//

import SceneKit

class DummyNode: SCNNode {
    
    override init() {
        super.init()
        setupNode()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupNode() {
        let floorScene = SCNScene(named: "floor_demo.scn",
                                  inDirectory: "SeatMap.scnassets",
                                  options: nil)
        guard let floorNode = floorScene?.rootNode.childNode(withName: "floor", recursively: false) else {
            print("No Model")
            return }
        
        self.addChildNode(floorNode)
    }
}
