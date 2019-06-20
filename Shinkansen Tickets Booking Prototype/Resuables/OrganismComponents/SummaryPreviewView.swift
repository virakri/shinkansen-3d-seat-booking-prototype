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
    
    var cameraControlNode: SCNNode!
    
    var contentNode: SCNNode!
    
    var scene: SCNScene!
    
    // TODO: Obtain model from seat class...
    var selectedReservableEntity: ReservableEntity? {
        didSet {
            contentNode?.childNodes
                .filter({ $0.categoryBitMask == ReservableNode.defaultBitMask})
                .forEach {
                    $0.removeFromParentNode()
            }
            if let name = selectedReservableEntity?.transformedModelEntity.modelEntity,
                let node: SeatNode = NodeFactory.shared?.create(name: name) {
                node.position = SCNVector3(0, 0, 0)
                node.eulerAngles = SCNVector3(0, -Float.pi / 6, 0)
                contentNode.addChildNode(node)
            }else{
                contentNode.addChildNode(RedBoxNode())
            }
        }
    }
    
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
            
            tiltNodeMotionEffect.horizontalTiltedIntensity = -1 / 2
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
    
    private func playInitialAnimation() {
        
        weak var contentNode = self.contentNode
        
        contentNode?.scale = SCNVector3(0.1, 0.1, 0.1)
        contentNode?.eulerAngles = SCNVector3(0, Float.pi * 2, 0)
        SceneKitAnimator.animateWithDuration(
            duration: 0.35 * 2,
            timingFunction: .explodingEaseOut,
            animations: {
                contentNode?.scale = SCNVector3(1.1, 1.1, 1.1)
                contentNode?.eulerAngles = SCNVector3(0, Float.pi * -0.25, 0)
        },
            completion: {
                SceneKitAnimator.animateWithDuration(
                    duration: 0.35 / 2,
                    timingFunction: .easeInEaseOut,
                    animations: {
                        contentNode?.scale = SCNVector3(1, 1, 1)
                        contentNode?.eulerAngles = SCNVector3(0, 0, 0)
                })
        })
    }
}
