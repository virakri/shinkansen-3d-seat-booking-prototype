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
    
    var selectedReservableEntity: ReservableEntity? {
        didSet {
            contentNode?.childNodes
                .filter({ $0.categoryBitMask == ReservableNode.defaultBitMask})
                .forEach {
                    $0.removeFromParentNode()
            }
            if let name = selectedReservableEntity?.transformedModelEntity.modelEntity,
                let node: SeatNode = NodeFactory.shared?.create(name: name) {
                node.position = SCNVector3Make(0, -1, 0)
                node.eulerAngles = .zero
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
        
        contentNode = SCNNode()
        scene.rootNode.addChildNode(contentNode)
        
        let camera = SCNCamera()
        let cameraNode = SCNNode()
        cameraNode.camera = camera
        cameraNode.position.z = 2
        cameraNode.position.y = 0.5
        cameraNode.look(at: .init())
        
        scene.rootNode.addChildNode(cameraNode)
        
        sceneView.scene = scene
    }
}
