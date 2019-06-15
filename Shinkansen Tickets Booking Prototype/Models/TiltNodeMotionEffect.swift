//
//  TiltMotionEffectNode.swift
//  Shinkansen Tickets Booking Prototype
//
//  Created by Nattawut Singhchai on 15/6/2019 .
//  Copyright © 2019 Virakri Jinangkul. All rights reserved.
//

import SceneKit

class TiltNodeMotionEffect: UIMotionEffect {
    
    private var basedEulerAngles = SCNVector3Zero
    private var basedPosition = SCNVector3Zero
    
    /// `SCNNode` that will be tilted or reposition based on visual effect
    var node: SCNNode?
    
    /// Intensity of vertical tilt
    var verticalAngleIntensity: CGFloat = 1 / 4
    
    /// Intensity of horizontal tilt
    var horizontalAngleIntensity: CGFloat = 1 / 4
    
    /// Add motion effect to `SCNNode`
    ///
    /// - Parameter node: `SCNNode` that will be tilted or reposition based on visual effect
    init(node: SCNNode) {
        super.init()
        self.node = node // Set value at init
        basedPosition = node.position
        basedEulerAngles = node.eulerAngles
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func keyPathsAndRelativeValues(forViewerOffset viewerOffset: UIOffset) -> [String : Any]? {
        /// Example for position manipulation
/*
        node?.position = SCNVector3Make(
            basePosition.x + Float(viewerOffset.horizontal * horizontalAngle),
            basePosition.y - Float(viewerOffset.vertical * verticalAngle),
            basePosition.z )
 */
        node?.eulerAngles = SCNVector3Make(basedEulerAngles.x + Float(viewerOffset.vertical * verticalAngleIntensity), basedEulerAngles.y + Float(viewerOffset.horizontal * horizontalAngleIntensity), basedEulerAngles.z)
        return nil
    }
}

