//
//  TiltMotionEffectNode.swift
//  Shinkansen Tickets Booking Prototype
//
//  Created by Nattawut Singhchai on 15/6/2019 .
//  Copyright © 2019 Virakri Jinangkul. All rights reserved.
//

import SceneKit

class TiltNodeMotionEffect: UIMotionEffect {
    
    var node: SCNNode? // The object you want to tilt
    var baseOrientation = SCNVector3Zero
    var basePosition = SCNVector3Zero
    
    //TODO: Change intensity
    var verticalAngle: CGFloat = 0.5
    var horizontalAngle: CGFloat = 0.3
    
    init(node: SCNNode) {
        super.init()
        self.node = node // Set value at init
        basePosition = node.position
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func keyPathsAndRelativeValues(forViewerOffset viewerOffset: UIOffset) -> [String : Any]? {
        // TODO: Change this to position instead.
        /// ตัวอย่าง
        node?.position = SCNVector3Make(
            basePosition.x + Float(viewerOffset.horizontal * horizontalAngle),
            basePosition.y - Float(viewerOffset.vertical * verticalAngle),
            basePosition.z )
//        node?.eulerAngles = SCNVector3Make(baseOrientation.x + Float(viewerOffset.vertical * verticalAngle), baseOrientation.y + Float(viewerOffset.horizontal * horizontalAngle), baseOrientation.z)
        return nil
    }
}

