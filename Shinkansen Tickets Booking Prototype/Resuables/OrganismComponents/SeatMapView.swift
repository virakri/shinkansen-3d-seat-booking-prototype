//
//  SeatMapSceneView.swift
//  Shinkansen Tickets Booking Prototype
//
//  Created by Virakri Jinangkul on 6/6/19.
//  Copyright © 2019 Virakri Jinangkul. All rights reserved.
//

import UIKit
import SceneKit

protocol SeatMapSceneViewDelegate {
    func sceneViewDidPanFurtherUpperBoundLimit(by offset: CGPoint)
    func sceneView(sceneView: SeatMapSceneView, didSelected reservableEntity: ReservableEntity)
}

extension SeatMapSceneViewDelegate {
    func sceneViewDidPanFurtherUpperBoundLimit(by offset: CGPoint) { }
    func sceneView(sceneView: SeatMapSceneView, didSelected reservableEntity: ReservableEntity) {}
}

class SeatMapSceneView: SCNView {
    
    var seatMapDelegate: SeatMapSceneViewDelegate?
    
    var bottomOffset: CGFloat = 0
    
    var contentNode: SCNNode = SCNNode()
    
    // Dirty zones
    var hitTestPositionWhenTouchBegan: SCNVector3?
    
    var contentNodePositionWhenTouchBegan: SCNVector3?
    
    var currectContentNodePosition: SCNVector3? {
        didSet {
            print(currectContentNodePosition ?? "This is Nil")
            contentNode.position = currectContentNodePosition ?? contentNode.position
            
            guard let currectContentNodePosition = currectContentNodePosition, let oldValue = oldValue else { return }
            perspectiveVelocity = (currectContentNodePosition.z - oldValue.z) / (1 / 60)
            
            // Conform to the delegate
            let upperBoundLimitOffsetY: CGFloat = CGFloat(contentZPositionLimit.upperBound - currectContentNodePosition.z)
            seatMapDelegate?
                .sceneViewDidPanFurtherUpperBoundLimit(by: CGPoint(x: 0,
                                                                   y: upperBoundLimitOffsetY / 0.04))
            
        }
    }
    
    private var selectingSeat: ReservableNode? {
        didSet {
            if let selectingSeat = selectingSeat, selectingSeat != selectingSeat {
                selectingSeat.isHighlighted = true
            }
        }
    }
    
    private var selectedSeat: ReservableNode? {
        didSet {
            if oldValue != selectedSeat {
                oldValue?.isHighlighted = false
                if selectingSeat != selectedSeat {
                    selectingSeat?.isHighlighted = false
                }
                selectedSeat?.isHighlighted = true
                selectingSeat = nil
                
                if let reservableEntity = selectedSeat?.reservableEntity {
                    seatMapDelegate?.sceneView(sceneView: self, didSelected: reservableEntity)
                }
            }
        }
    }
    
    var perspectiveVelocity: Float?
    
    var contentZPositionLimit: ClosedRange<Float> = -2...25
    
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
        scene.background.contents = UIColor.clear
        
        contentNode.addChildNode(dummyNode)
        currectContentNodePosition = contentNode.position
        
        scene.rootNode.addChildNode(hitTestFloorNode)
        scene.rootNode.addChildNode(contentNode)

        scene.rootNode.addChildNode(cameraNode)
        
        self.scene = scene
    }
    
    private func setupInteraction() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureDidPan))
        addGestureRecognizer(panGesture)
    }
    
    public func setupContent(seatClassEntity: SeatClassEntity?) {
        
        guard let seatClassEntity = seatClassEntity else {
            return
        }
        
        DispatchQueue.global(qos: .background).async {
            let nodes: [ReservableNode] = seatClassEntity.reservableEntities.map({
                BoxTesterNode(reservableEntity: $0)
            })
            
            nodes.forEach { node in
                self.contentNode.addChildNode(node)
            }
        }
    }
    
    private func filterReservationNodeFrom(_ touches: Set<UITouch>) -> ReservableNode? {
        if let touch = touches.first {
            let firstHitTestResult = hitTest(touch.location(in: self), options: [.categoryBitMask: ReservableNode.defaultBitMask]).first
            if let node = firstHitTestResult?.node as? ReservableNode {
                return node
            }
        }
        return nil
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        contentNode.removeAction(forKey: "panDrift")
        
        if let node = filterReservationNodeFrom(touches){
            selectingSeat = node
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        if let node = filterReservationNodeFrom(touches), node == selectingSeat {
            node.isHighlighted = false
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let node = filterReservationNodeFrom(touches) {
            if node != selectingSeat {
                selectingSeat?.isHighlighted = false
            }
            selectingSeat = nil
            selectedSeat = node
        }
    }
    
    private func zPositionClamp(_ value: Float) -> Float {
        let trimmedMaxValue = value > contentZPositionLimit.upperBound ? contentZPositionLimit.upperBound * (1 + log10(value/contentZPositionLimit.upperBound)) : value
//
        return value < contentZPositionLimit.lowerBound ? contentZPositionLimit.lowerBound * (1 + log10( trimmedMaxValue  / contentZPositionLimit.lowerBound )) : trimmedMaxValue
    }
    
    private func positionOfFloorHitTest(_ point: CGPoint) -> SCNVector3? {
        let hitTests = hitTest(point, options: [.categoryBitMask : 1 << 1])
        print(hitTests)
        return hitTests.first?.worldCoordinates
    }
    
    @objc private func panGestureDidPan(_ sender: UIPanGestureRecognizer) {
        
        let location = sender.location(in: self)
        
        switch sender.state {
        case .began:
            hitTestPositionWhenTouchBegan = positionOfFloorHitTest(location)
            contentNodePositionWhenTouchBegan = contentNode.position
            
        case .changed:
            // Temporary
            
            let hitTestPositionWhereCurrentTouch = positionOfFloorHitTest(location)
            
            if let hitTestPositionWhereTouchBegan = hitTestPositionWhenTouchBegan,
                let hitTestPositionWhereCurrentTouch = hitTestPositionWhereCurrentTouch,
                let contentNodePositionWhereTouchBegan = contentNodePositionWhenTouchBegan {
                
                let zPosition = zPositionClamp(hitTestPositionWhereCurrentTouch.z - hitTestPositionWhereTouchBegan.z + contentNodePositionWhereTouchBegan.z)
                self.currectContentNodePosition?.z = zPosition
            }
            
            //            currectContentNodePosition = contentNode.position
            
            
            
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
                        
                        self.currectContentNodePosition?.z = (newZPosition + self.zPositionClamp(newZPosition)) / 2
                        
                        self.currectContentNodePosition = self.contentNode.position
                        
                        currentVelocity = newStep.velocity
                        currentTime = elapsedTime
                })
            
            contentNode.runAction(driftAction,
                                      forKey: "panDrift",
                                      completionHandler:{
                                        
                                        // reset the position of the content if it goes beyond the position limit after the panDrift animation
                                        if (self.currectContentNodePosition?.z ?? 0) > self.contentZPositionLimit.upperBound {
                                            self.currectContentNodePosition?.z = self.contentZPositionLimit.upperBound
                                        }
                                        
                                        else if (self.currectContentNodePosition?.z ?? 0) < self.contentZPositionLimit.lowerBound {
                                            self.currectContentNodePosition?.z = self.contentZPositionLimit.lowerBound
                                        }
            })
        
        
        default:
        break
        }
    }
}
