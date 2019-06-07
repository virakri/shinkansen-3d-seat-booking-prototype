//
//  SeatMapSceneView.swift
//  Shinkansen Tickets Booking Prototype
//
//  Created by Virakri Jinangkul on 6/6/19.
//  Copyright © 2019 Virakri Jinangkul. All rights reserved.
//

import UIKit
import SceneKit

class SeatMapSceneView: SCNView {
    
    var bottomOffset: CGFloat = 0
    
    var contentNode: SCNNode = SCNNode()
    
    init() {
        super.init(frame: .zero, options: nil)
        
        setupView()
        setupScene()
        setupInteraction()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = .clear
    }
    
    private func setupScene() {
        
        // Temporary
        let dummyNode = DummyNode()
        
        let hitTestFloorNode = HitTestFloorNode()
        
        let cameraNode = CameraNode()
        
        let scene = SCNScene()
        
        contentNode.addChildNode(dummyNode)
        
        scene.rootNode.addChildNode(hitTestFloorNode)
        scene.rootNode.addChildNode(contentNode)
        
        scene.rootNode.addChildNode(cameraNode)
        
        self.scene = scene
    }
    
    private func setupInteraction() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureDidPan))
        addGestureRecognizer(panGesture)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        contentNode.removeAction(forKey: "panDrift")
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    // Dirty zones
    var hitTestPositionWhereTouchBegan: SCNVector3?
    
    var contentNodePositionWhereTouchBegan: SCNVector3?
    
    var currectContentNodePosition: SCNVector3? {
        didSet {
            guard let currectContentNodePosition = currectContentNodePosition, let oldValue = oldValue else { return }
            perspectiveVelocity = (currectContentNodePosition.z - oldValue.z) / (1 / 60)
            print(perspectiveVelocity)
        }
    }
    
    var perspectiveVelocity: Float?
    
    var contentZPositionLimit: ClosedRange<Float> = -1...25
    
    private func zPositionClamp(_ value: Float) -> Float {
        let trimmedMaxValue = value > contentZPositionLimit.upperBound ? contentZPositionLimit.upperBound * (1 + log10(value/contentZPositionLimit.upperBound)) : value
//
        return value < contentZPositionLimit.lowerBound ? contentZPositionLimit.lowerBound * (1 + log10( trimmedMaxValue  / contentZPositionLimit.lowerBound )) : trimmedMaxValue
    }
    
    private func positionOfFloorHitTest(_ point: CGPoint) -> SCNVector3? {
        let hitTests = hitTest(point, options: [.categoryBitMask : 1 << 1])
        return hitTests.first?.worldCoordinates
    }
    
    @objc private func panGestureDidPan(_ sender: UIPanGestureRecognizer) {
        
        let location = sender.location(in: self)
        
        switch sender.state {
        case .began:
            hitTestPositionWhereTouchBegan = positionOfFloorHitTest(location)
            contentNodePositionWhereTouchBegan = contentNode.position
            
        case .changed:
            // Temporary
            
            let hitTestPositionWhereCurrentTouch = positionOfFloorHitTest(location)
            
            if let hitTestPositionWhereTouchBegan = hitTestPositionWhereTouchBegan,
                let hitTestPositionWhereCurrentTouch = hitTestPositionWhereCurrentTouch,
                let contentNodePositionWhereTouchBegan = contentNodePositionWhereTouchBegan{
                let zPosition = zPositionClamp(hitTestPositionWhereCurrentTouch.z - hitTestPositionWhereTouchBegan.z + contentNodePositionWhereTouchBegan.z)
                contentNode.position.z = zPosition
            }
            
            currectContentNodePosition = contentNode.position
            
            
            
        case .ended:
            
//            currectContentNodePosition = contentNode.position
            
            var currentTime: CGFloat = 0
            var currentVelocity = CGPoint(x: 0, y: CGFloat(perspectiveVelocity ?? 0))//
            
//            sender.velocity(in: self)
            
            let driftAction = SCNAction
                .customAction(duration: DecayFunction
                    .timeToHalt(velocity: currentVelocity), action: {
                        (node, elapsedTime) in
                        let newStep = DecayFunction
                            .step(timeElapsed: CFTimeInterval(elapsedTime - currentTime),
                                  velocity: currentVelocity)
                        
//                        let xDisplacment = newStep.displacement.x
                        let yDisplacment = newStep.displacement.y
                        
                        let newZPosition = self.contentNode.position.z + Float(yDisplacment)
                        
                        self.contentNode.position.z = (newZPosition + self.zPositionClamp(newZPosition)) / 2
                        
                        currentVelocity = newStep.velocity
                        currentTime = elapsedTime
                })
            
            contentNode.runAction(driftAction,
                                      forKey: "panDrift",
                                      completionHandler:{
                                        
                                        // reset the position of the content if it goes beyond the position limit after the panDrift animation
                                        if self.contentNode.position.z > self.contentZPositionLimit.upperBound {
                                            self.contentNode.position.z = self.contentZPositionLimit.upperBound
                                        }
                                        
                                        else if self.contentNode.position.z < self.contentZPositionLimit.lowerBound {
                                            self.contentNode.position.z = self.contentZPositionLimit.lowerBound
                                        }
            })
        
        
        default:
        break
        }
    }
}
