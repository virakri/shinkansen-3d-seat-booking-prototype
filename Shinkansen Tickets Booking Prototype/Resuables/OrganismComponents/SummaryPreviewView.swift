//
//  SummaryPreviewView.swift
//  Shinkansen Tickets Booking Prototype
//
//  Created by Virakri Jinangkul on 6/19/19.
//  Copyright © 2019 Virakri Jinangkul. All rights reserved.
//

import UIKit
import SceneKit

class SummaryPreviewView: UIView {
    
    var sceneView: SCNView
    
    var contentNode: SCNNode!
    
    init() {
        sceneView = SCNView(frame: .zero, options: [:])
        super.init(frame: .zero)
        setupView()
        setupScene()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        // MARK: Add visual effect
        let tiltNodeMotionEffect = TiltNodeMotionEffect(node: contentNode)
        
        tiltNodeMotionEffect.horizontalShiftedIntensity = 0
        tiltNodeMotionEffect.verticalShiftedIntensity = 0
        
        tiltNodeMotionEffect.horizontalTiltedIntensity = 1 / 2
        tiltNodeMotionEffect.verticalTiltedIntensity = 1 / 2
        
        superview?.addMotionEffect(tiltNodeMotionEffect)
    }
    
    private func setupView() {
        addSubview(sceneView, withConstaintEquals: .edges)
    }
    
    private func setupScene(){
        // Temporary
        
        let scene = SCNScene()
        
        let box = SCNBox(width: 1, height: 1, length: 1, chamferRadius: 0)
        box.firstMaterial?.diffuse.contents = UIColor.red
        box.firstMaterial?.lightingModel = .blinn
        let boxNode = SCNNode(geometry: box)
        contentNode = SCNNode()
        
        contentNode.addChildNode(boxNode)
        scene.rootNode.addChildNode(contentNode)
        
        let camera = SCNCamera()
        let cameraNode = SCNNode()
        cameraNode.camera = camera
        cameraNode.position.z = 5
        cameraNode.look(at: .init())
        
        scene.rootNode.addChildNode(cameraNode)
        
        sceneView.scene = scene
    }
}
