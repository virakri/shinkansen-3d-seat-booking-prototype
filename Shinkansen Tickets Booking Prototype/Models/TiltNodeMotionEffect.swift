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
    weak var node: SCNNode?
    
    /// Intensity of vertical tilt
    var verticalTiltedIntensity: CGFloat = 1 / 4
    
    /// Intensity of horizontal tilt
    var horizontalTiltedIntensity: CGFloat = 1 / 24
    
    /// Intensity of vertical shift
    var verticalShiftedIntensity: CGFloat = 0
    
    /// Intensity of horizontal shift
    var horizontalShiftedIntensity: CGFloat = 1 / 2
    
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

        // Shifting position
        node?.position = SCNVector3Make(
            basedPosition.x + Float(viewerOffset.horizontal * horizontalShiftedIntensity),
            basedPosition.y - Float(viewerOffset.vertical * verticalShiftedIntensity),
            basedPosition.z )
 
        // Tilting Angle
        node?.eulerAngles = SCNVector3Make(basedEulerAngles.x + Float(viewerOffset.vertical * verticalTiltedIntensity), basedEulerAngles.y + Float(viewerOffset.horizontal * horizontalTiltedIntensity), basedEulerAngles.z)
        return nil
    }
}

