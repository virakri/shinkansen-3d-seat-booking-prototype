//
//  SeatMapSceneView.swift
//  Shinkansen Tickets Booking Prototype
//
//  Created by Virakri Jinangkul on 6/6/19.
//  Copyright © 2019 Virakri Jinangkul. All rights reserved.
//

import UIKit
import SceneKit

protocol SeatMapSceneViewDelegate: AnyObject {
    func sceneViewDidPanFurtherUpperBoundLimit(by offset: CGPoint)
    func sceneView(sceneView: SeatMapSceneView, didSelected reservableEntity: ReservableEntity)
}

extension SeatMapSceneViewDelegate {
    func sceneViewDidPanFurtherUpperBoundLimit(by offset: CGPoint) { }
    func sceneView(sceneView: SeatMapSceneView, didSelected reservableEntity: ReservableEntity) {}
}

class SeatMapSceneView: SCNView {
    
    private let lightFeedbackGenerator = UIImpactFeedbackGenerator(style: .light)
    
    weak var seatMapDelegate: SeatMapSceneViewDelegate?
    
    private var bottomOffset: CGFloat = 0
    
    private var contentNode: SCNNode! = SCNNode()
    
    private var cameraNode: CameraNode! = CameraNode()
    
    private var hitTestPositionWhenTouchBegan: SCNVector3?
    
    private var contentNodePositionWhenTouchBegan: SCNVector3?
    
    private var loadingActivityIndicatorView: UIView! = UIView()
    
    private var currectContentNodePosition: SCNVector3? {
        didSet {
            setCurrectContentNodePosition(
                currectContentNodePosition: currectContentNodePosition,
                oldValue: oldValue
            )
        }
    }
    
    private var highlightedSeats = Set<ReservableNode>() {
        didSet {
            oldValue.subtracting(highlightedSeats).forEach { $0.isHighlighted = false }
            highlightedSeats.subtracting(oldValue).forEach {
                $0.isHighlighted = true
                lightFeedbackGenerator.impactOccurred()
            }
        }
    }
    
    private weak var selectedSeat: ReservableNode? {
        didSet {
            oldValue?.isSelected = false
            selectedSeat?.isSelected = true
            if let reservableEntity = selectedSeat?.reservableEntity {
                seatMapDelegate?.sceneView(sceneView: self, didSelected: reservableEntity)
            }
            if let selectedSeat = selectedSeat {
                let center = positionOfFloorHitTest(.init(x: 0, y: frame.midY))?.z ?? 0
                SceneKitAnimator.animateWithDuration(
                    duration: 0.35 * 2,
                    timingFunction: .easeOut,
                    animations: {
                        currectContentNodePosition?.z = -(selectedSeat.position.z) + center
                })
            }
        }
    }
    
    var perspectiveVelocity: Float?
    
    var contentZPositionLimit: ClosedRange<Float> = -2...25
    
    // MARK: Initialzer & Setup
    
    init() {
        super.init(frame: .zero, options: nil)
        setupView()
        setupScene()
        setupInteraction()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// View setup
    private func setupView() {
        backgroundColor = .clear
        
        // Set Antialiasing Mode depending on the density of the pixels, so if the screen is 3X, the view will use `multisampling2X` otherwise it will use ``multisampling4X`
        antialiasingMode = UIScreen.main.scale > 2 ?
            .multisampling2X : .multisampling4X
        
        loadingActivityIndicatorView.backgroundColor = currentColorTheme.componentColor.cardBackground
        let indicatorView = UIActivityIndicatorView(style: .whiteLarge)
        indicatorView.color = currentColorTheme.componentColor.secondaryText
        indicatorView.startAnimating()
        loadingActivityIndicatorView
            .addSubview(indicatorView,
                        withConstaintEquals: .centerSafeArea,
                        insetsConstant: .init(bottom: 48))
        addSubview(loadingActivityIndicatorView, withConstaintEquals: .edges)
        
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        // MARK: Add visual effect
        superview?.addMotionEffect(TiltNodeMotionEffect(node: cameraNode))
    }
    
    /// Scene setup
    private func setupScene() {
        
        // Temporary
        let dummyNode = DummyNode()
        
        let hitTestFloorNode = HitTestFloorNode()
        
        let scene = SCNScene()
        scene.background.contents = currentColorTheme.componentColor.cardBackground
        
        contentNode.addChildNode(dummyNode)
        currectContentNodePosition = contentNode.position
        
        scene.rootNode.addChildNode(hitTestFloorNode)
        scene.rootNode.addChildNode(contentNode)
        scene.rootNode.addChildNode(cameraNode)
        
        self.scene = scene
    }
    
    private func placeStaticNodes(from factory: NodeFactory,
                                  using transformedModelEntities: [TransformedModelEntity],
                                  isEnabled: Bool = true) {
        let staticNode = SCNNode()
        
        // Place static nodes
        transformedModelEntities.compactMap({
            if let node: ObjectNode = factory.create(name: $0.modelEntity) {
                node.transformedModelEntity = $0
                node.isEnabled = isEnabled
                return node
            }
            return nil
        }).forEach {
            staticNode.addChildNode($0)
        }
        DispatchQueue.main.async { [weak self] in
            self?.contentNode?.addChildNode(staticNode)
        }
    }
    
    deinit {
        workItems.forEach { $0.cancel() }
        workItems.removeAll()
    }
    
    var workItems: [DispatchWorkItem] = []
    
    private let currentEntityQueue = DispatchQueue(label: "Current Entity Placing Queue", qos: .utility)
    private let otherEntityQueue = DispatchQueue(label: "Placing Object Queue", qos: .background)
    
    private func placeSeatClassNodes(from factory: NodeFactory,
                                     seatClassEntity: SeatClassEntity,
                                     isCurrentEntity: Bool) {
        var workItem: DispatchWorkItem!
        
        workItem = DispatchWorkItem { [weak self] in
            guard !workItem.isCancelled else { return }
            // Generate all interactible nodes with transform values
            let containerNode = SCNNode()
            containerNode.name = seatClassEntity.name
            let nodes: [ReservableNode] = seatClassEntity.reservableEntities.compactMap({
                guard !workItem.isCancelled else {
                    return nil
                }
                if let node: SeatNode = factory.create(name: $0.transformedModelEntity.modelEntity) {
                    node.reservableEntity = $0
                    
                    // Assign Enabled state of interactible nodes
                    node.setEnabled($0.isAvailable && isCurrentEntity, animated: false)
                    return node
                }
                /// Show Error node
                let node = RedBoxNode()
                node.reservableEntity = $0
                return node
            })
            nodes.forEach { node in
                if !workItem.isCancelled {
                    containerNode.addChildNode(node)
                }
            }
            guard !workItem.isCancelled else { return }
            self?.placeStaticNodes(from: factory,
                                   using: seatClassEntity.transformedModelEntities,
                                   isEnabled: isCurrentEntity)
            DispatchQueue.main.async {
                self?.contentNode?.addChildNode(containerNode)
                if isCurrentEntity {
                    self?.loadingActivityIndicatorView?.removeFromSuperview()
                    self?.alpha = 0
                    UIView.animate(withDuration: 0.35, animations: {
                        self?.alpha = 1
                    })
                }
            }
        }
        
        (isCurrentEntity ? currentEntityQueue : otherEntityQueue).async(execute: workItem)
        workItems.append(workItem)
    
    }
    
    public func setupContent(seatMap: SeatMap,
                             currentEntity: SeatClassEntity) {
        
        setupGlobalStaticContent(seatMap: seatMap)
        
        var seatClassEntities = seatMap.seatClassEntities
        
        // Reorder to have current seatClassEnity to be first memeber of the array
        if let index = seatClassEntities.firstIndex(where: { $0 === currentEntity }) {
            seatClassEntities.remove(at: index)
            seatClassEntities.insert(currentEntity, at: 0)
        }
        
        seatClassEntities.forEach {
            let isCurrentEntity = $0 === currentEntity
            
            if isCurrentEntity {
                // Set Seat Range
                contentZPositionLimit = $0
                    .viewableRange
                    .lowerBound.z...$0
                        .viewableRange
                        .upperBound.z
                
                // Set origin of the content to be center between lowerBound and upperbound
                currectContentNodePosition?.z =
                    ($0.viewableRange.lowerBound.z +
                        $0.viewableRange.upperBound.z) / 2
            }
            
            setupSeatClassContent(seatClassEntity: $0,
                                  isCurrentEntity: isCurrentEntity)
        }
    }
    
    private func setupGlobalStaticContent(seatMap: SeatMap) {
        
        if let factory = NodeFactory.shared {
            if factory.isLoaded {
                DispatchQueue.global(qos: .background).async { [weak self] in
                    self?.placeStaticNodes(from: factory,
                                           using: seatMap.transformedModelEntities)
                }
            }else{
                factory.onComplete { [weak self] in
                    self?.placeStaticNodes(from: $0,
                                           using: seatMap.transformedModelEntities)
                }
            }
        }else{
            fatalError("NodeFactory is not defined before used")
        }
    }
    
    private func setupSeatClassContent(seatClassEntity: SeatClassEntity,
                                       isCurrentEntity: Bool = true) {
        
        if let factory = NodeFactory.shared {
            if factory.isLoaded {
                DispatchQueue.global(qos: .background).async { [weak self] in
                    self?.placeSeatClassNodes(from: factory,
                                              seatClassEntity: seatClassEntity,
                                              isCurrentEntity: isCurrentEntity)
                }
            }else{
                factory.onComplete { [weak self] in
                    self?.placeSeatClassNodes(from: $0,
                                              seatClassEntity: seatClassEntity,
                                              isCurrentEntity: isCurrentEntity)
                }
            }
        }else{
            fatalError("NodeFactory is not defined before used")
        }
    }
    
    private func setupInteraction() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureDidPan))
        panGesture.maximumNumberOfTouches = 1
        addGestureRecognizer(panGesture)
    }
    
    // MARK: State Change / Update
    
    private func setCurrectContentNodePosition(currectContentNodePosition: SCNVector3?, oldValue: SCNVector3?) {
        contentNode.position = currectContentNodePosition ?? contentNode.position
        
        guard let currectContentNodePosition = currectContentNodePosition, let oldValue = oldValue else { return }
        perspectiveVelocity = (currectContentNodePosition.z - oldValue.z) / (1 / 60)
        
        // Conform to the delegate
        let upperBoundLimitOffsetY: CGFloat = CGFloat(contentZPositionLimit.upperBound - currectContentNodePosition.z)
        seatMapDelegate?
            .sceneViewDidPanFurtherUpperBoundLimit(by: CGPoint(x: 0,
                                                               y: upperBoundLimitOffsetY / 0.04))
    }
    
    // MARK: Gestures
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        contentNode.removeAction(forKey: "panDrift")
        for node in filterReservationNodeFrom(touches) {
            highlightedSeats.insert(node)
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        if highlightedSeats.count > 0 {
            highlightedSeats.removeAll()
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        if let node = touches.compactMap ({ touch in
            highlightedSeats.first { $0.touch == touch }
        }).first {
            selectedSeat = node
            highlightedSeats.remove(node)
        }
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
        case .ended:
            
            var currentTime: CGFloat = 0
            var currentVelocity = CGPoint(x: 0, y: CGFloat(perspectiveVelocity ?? 0))
            
            let driftAction = SCNAction
                .customAction(duration: DecayFunction
                    .timeToHalt(velocity: currentVelocity), action: {
                        [weak self] (node, elapsedTime) in
                        guard let self = self else { return }
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
                                  completionHandler:{ [weak self] in
                                    guard let self = self else { return }
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
    
    // MARK: Utility & Helper
    
    /// Recursive find parent node that be `ReservableNode` class
    /// - Parameter node: Target node to find
    func findParent(of node: SCNNode?) -> ReservableNode? {
        guard let node = node else {
            return nil
        }
        if let node = node as? ReservableNode {
            return node
        }
        return findParent(of: node.parent)
    }
    
    /// Get nodes from touches position
    /// - Parameter touches: Set of touch to determine
    private func filterReservationNodeFrom(_ touches: Set<UITouch>) -> [ReservableNode] {
        return touches.compactMap { touch in
            let firstHitTestResult = hitTest(touch.location(in: self),
                                             options: [.categoryBitMask: ReservableNode.defaultBitMask]).first
            if let node = firstHitTestResult?.node,
                let parent = findParent(of: node),
                parent.isEnabled {
                parent.touch = touch
                return parent
            }
            return nil
        }
    }
    
    private func zPositionClamp(_ value: Float) -> Float {
        let trimmedMaxValue = value > contentZPositionLimit.upperBound ? contentZPositionLimit.upperBound * (1 + log10(value/contentZPositionLimit.upperBound)) : value
        
        return value < contentZPositionLimit.lowerBound ? contentZPositionLimit.lowerBound * (1 + log10( trimmedMaxValue  / contentZPositionLimit.lowerBound )) : trimmedMaxValue
    }
    
    private func positionOfFloorHitTest(_ point: CGPoint) -> SCNVector3? {
        let hitTests = hitTest(point, options: [.categoryBitMask : 1 << 1])
        return hitTests.first?.worldCoordinates
    }
    
}
