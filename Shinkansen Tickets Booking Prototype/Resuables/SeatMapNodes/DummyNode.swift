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
        let floorRootNode = SCNReferenceNode(url: .resource(name: "floor_demo.scn")!)
        floorRootNode?.load()
        guard let floorNode = floorRootNode?.childNode(withName: "floor", recursively: false) else {
            print("No Model")
            return }
        
//        self.addChildNode(floorNode)
    }
}
