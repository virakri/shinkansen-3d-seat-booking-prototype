//
//  SummaryPreviewView.swift
//  Shinkansen 3D Seat Booking Prototype
//
//  Created by Virakri Jinangkul on 6/19/19.
//  Copyright © 2019 Virakri Jinangkul. All rights reserved.
//

import UIKit
import SceneKit

class SummaryPreviewView: UIView {
    
    var sceneView: SCNView
    
    var cameraControlNode: SCNNode!
    
    var contentNode: SCNNode!
    
    var scene: SCNScene!
    
    init() {
        sceneView = SCNView(frame: .zero, options: [:])
        super.init(frame: .zero)
        setupView()
        setupScene()
        setupCamera()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        if let cameraControlNode = cameraControlNode {
            // MARK: Add visual effect
            let tiltNodeMotionEffect = TiltNodeMotionEffect(node: cameraControlNode)
            
            tiltNodeMotionEffect.horizontalShiftedIntensity = 0
            tiltNodeMotionEffect.verticalShiftedIntensity = 0
            
            tiltNodeMotionEffect.horizontalTiltedIntensity = 1 / 2
            tiltNodeMotionEffect.verticalTiltedIntensity = 1 / 2
            
            superview?.addMotionEffect(tiltNodeMotionEffect)
        }
        
        playInitialAnimation()
    }
    
    private func setupView() {
        addSubview(sceneView, withConstaintEquals: .edges)
        
        // Set Antialiasing Mode depending on the density of the pixels, so if the screen is 3X, the view will use `multisampling2X` otherwise it will use ``multisampling4X`
        sceneView.antialiasingMode = UIScreen.main.scale > 2 ?
            .multisampling2X : .multisampling4X
    }
    
    private func setupScene(){
        
        // Temporary
        scene = SCNScene()
        sceneView.scene = scene
        
        contentNode = SCNNode()
        scene.rootNode.addChildNode(contentNode)
        scene.background.contents = currentColorTheme.componentColor.cardBackground
    }
    
    private func setupCamera() {
        cameraControlNode = SCNNode()
        cameraControlNode.position.y = 0.75
        
        let camera = SCNCamera()
        camera.fieldOfView = 16
        camera.projectionDirection = .vertical
        let cameraNode = SCNNode()
        cameraNode.camera = camera
        cameraNode.position.z = 8
        cameraNode.position.y = 0.25
        cameraNode.look(at: .zero)
        
        cameraControlNode.addChildNode(cameraNode)
        scene.rootNode.addChildNode(cameraControlNode)
    }
    
    public func setupContent(withSeatClassType seatClassType: SeatClassType?) {
        contentNode?.childNodes
            .filter({ $0.categoryBitMask == ReservableNode.defaultBitMask})
            .forEach {
                $0.removeFromParentNode()
        }
        
        guard let seatClassType = seatClassType,
        let node: SeatNode =
            NodeFactory
                .shared?
                .create(name: seatClassType.completeNodeName)
            else { contentNode.addChildNode(RedBoxNode())
            return
        }
        node.position = SCNVector3(0, 0, 0)
        node.eulerAngles = SCNVector3(0, -Float.pi / 6, 0)
        contentNode.addChildNode(node)
    }
    
    private func playInitialAnimation() {
        
        weak var contentNode = self.contentNode
        
        contentNode?.scale = SCNVector3(0.1, 0.1, 0.1)
        contentNode?.eulerAngles = SCNVector3(0, Float.pi * 1.5, 0)
        SceneKitAnimator.animateWithDuration(
            duration: 0.35 * 1.5,
            timingFunction: .explodingEaseOut,
            animations: {
                contentNode?.scale = SCNVector3(1.066, 1.066, 1.066)
                contentNode?.eulerAngles = SCNVector3(0, Float.pi * -0.066, 0)
        },
            completion: {
                SceneKitAnimator.animateWithDuration(
                    duration: 0.35 / 1.5,
                    timingFunction: CAMediaTimingFunction(controlPoints: 0.33, 0, 0.33, 1),
                    animations: {
                        contentNode?.scale = SCNVector3(1, 1, 1)
                        contentNode?.eulerAngles = SCNVector3(0, 0, 0)
                })
        })
    }
}
