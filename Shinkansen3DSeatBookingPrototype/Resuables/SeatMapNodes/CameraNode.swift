//
//  CameraNode.swift
//  Shinkansen 3D Seat Booking Prototype
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
        
        let cameraPosition = SCNVector3(0, 7.2, 5)
        let offsetPosition = SCNVector3(0, 2, 1.5)
        
        let camera = SCNCamera()
        camera.motionBlurIntensity = 0.333
        camera.projectionDirection = .vertical
        camera.fieldOfView = 64
        camera.zNear = 1
        camera.zFar = 100
        
        let actualCameraNode = SCNNode()
        actualCameraNode.camera = camera
        actualCameraNode.position.y = cameraPosition.y - offsetPosition.y
        actualCameraNode.position.z = cameraPosition.z - offsetPosition.z
        actualCameraNode.look(at: SCNVector3(0, -offsetPosition.y, -offsetPosition.z))
        
        addChildNode(actualCameraNode)
        position.y = offsetPosition.y
        position.z = -cameraPosition.z + offsetPosition.z
    }
}
