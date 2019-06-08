//
//  CameraNode.swift
//  Shinkansen Tickets Booking Prototype
//
//  Created by Virakri Jinangkul on 6/7/19.
//  Copyright © 2019 Virakri Jinangkul. All rights reserved.
//

import SceneKit

class CameraNode: SCNNode {
    
    override init() {
        super.init()
        setupNode()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupNode() {
        
        let camera = SCNCamera()
        camera.projectionDirection = .vertical
        camera.fieldOfView = 50
        camera.zNear = 1
        camera.zFar = 100
        
        self.camera = camera
        position.y = 8
        look(at: SCNVector3(0, 0, -7.5))
    }
}
