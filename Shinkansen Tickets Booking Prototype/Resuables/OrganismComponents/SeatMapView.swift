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
        backgroundColor = .clear
        
        // Temporary
        let floorScene = SCNScene(named: "floor_demo.scn",
                                  inDirectory: "SeatMap.scnassets",
                                  options: nil)
        guard let floorNode = floorScene?.rootNode.childNode(withName: "floor", recursively: false) else {
            print("No Model")
            return }
        
        let hitTestFloor = SCNFloor()
        let hitTestFloorNode = SCNNode(geometry: hitTestFloor)
        hitTestFloorNode.position.y = 1.3
        hitTestFloorNode.categoryBitMask = 1 << 1
        
        
        let scene = SCNScene()
        
        // Camera
        let camera = SCNCamera()
        camera.projectionDirection = .vertical
        camera.fieldOfView = 70
        camera.zNear = 1
        camera.zFar = 100
        let cameraNode = SCNNode()
        cameraNode.camera = camera
        cameraNode.position.y = 7.5
        cameraNode.look(at: SCNVector3(0, 0, -6))
        
        
        // Add Node
        contentNode.addChildNode(floorNode)
        
        scene.rootNode.addChildNode(hitTestFloorNode)
        scene.rootNode.addChildNode(contentNode)
        scene.rootNode.addChildNode(cameraNode)
        
        self.scene = scene
        
        setupInteraction()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
//            contentNode.localTranslate(by: SCNVector3(0, 0, sender.velocity(in: sender.view!).y / 1000))
            
            currectContentNodePosition = contentNode.position
            
            let hitTestPositionWhereCurrentTouch = positionOfFloorHitTest(location)
            
            if let hitTestPositionWhereTouchBegan = hitTestPositionWhereTouchBegan,
                let hitTestPositionWhereCurrentTouch = hitTestPositionWhereCurrentTouch,
            let contentNodePositionWhereTouchBegan = contentNodePositionWhereTouchBegan{
                contentNode.position.z = hitTestPositionWhereCurrentTouch.z - hitTestPositionWhereTouchBegan.z + contentNodePositionWhereTouchBegan.z
            }
            
            
            
            
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
                        
                        let xDisplacment = newStep.displacement.x
                        let yDisplacment = newStep.displacement.y
                        
                        self.contentNode.position.z = self.contentNode.position.z + Float(yDisplacment)
                        
                        //                    self.cameraNode.currentCameraPosition.x = calculateCameraPosition(of: self.cameraNode.currentCameraPosition.x, with: Float(yDisplacment) * self.panMultiplier)
                        //
                        //                    self.cameraNode.currentCameraPosition.y = calculateCameraPosition(of: self.cameraNode.currentCameraPosition.y, with: Float(xDisplacment) * self.panMultiplier)
                        
                        
                        currentVelocity = newStep.velocity
                        currentTime = elapsedTime
                })
            
            contentNode.runAction(driftAction,
                                      forKey: "panDrift",
                                      completionHandler:{})
        
        
        default:
        break
        }
    }
}

class SeatMapView: UIView {
    
    var seatMapSceneView: SeatMapSceneView!
    
    init() {
        seatMapSceneView = SeatMapSceneView()
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(seatMapSceneView, withConstaintEquals: .edges)
    }
}
