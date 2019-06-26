//
//  DesignSystemModel3DContentView.swift
//  Shinkansen3DSeatBookingPrototype
//
//  Created by Virakri Jinangkul on 6/23/19.
//  Copyright © 2019 Virakri Jinangkul. All rights reserved.
//

import Foundation

import UIKit
import SceneKit
import Kumi

class DesignSystemModel3DContentView: DesignSystemView {
    
    var currentContentView: UIView!
    
    var contentNode: SCNNode!
    
    var sceneView: SCNView!
    
    var cameraNode: SCNNode!
    
    var nodeLabel: Label!
    
    var availableNodes: [InteractiveNode] = []
    
    var factory: NodeFactory?
    
    private var loadingIndicator = UIActivityIndicatorView()
    
    override var state: UIControl.State {
        didSet {
            SceneKitAnimator.animateWithDuration(duration: 1, animations: {
                availableNodes.forEach {
                    $0.isEnabled = state != .disabled
                    $0.isSelected = state == .selected
                    $0.isHighlighted = state == .highlighted
                }
            })
        }
    }
    
    var currentNodeIndex: Int = 0 {
        didSet {
            if currentNodeIndex >= availableNodes.count {
                currentNodeIndex = 0
                
            } else if currentNodeIndex < 0 {
                currentNodeIndex = availableNodes.count - 1
                
            } else {
                availableNodes.forEach { $0.isHidden = true }
                let node = availableNodes[currentNodeIndex]
                node.isHidden = false
                nodeLabel.text = node.childNodes.first?.name
                sceneView.alpha = 0
                
                setCameraPositionByObjectBoundingSphere(center: node.boundingSphere.center,
                                                        radius: node.boundingSphere.radius)
                
                UIView.animate(withStyle: .transitionAnimationStyle,
                               animations: {
                    self.sceneView.alpha = 1
                })
            }
        }
    }
    
    private func setCameraPositionByObjectBoundingSphere(center: SCNVector3, radius: Float) {
        
        let cameraPosition = SCNVector3(center.x - radius * 0.75, center.y + radius, center.z + radius * 3)
        
        sceneView.defaultCameraController.stopInertia()
        sceneView.defaultCameraController.pointOfView?.position = cameraPosition
        sceneView.defaultCameraController.pointOfView?.look(at: center)
        sceneView.defaultCameraController.clearRoll()
        sceneView.defaultCameraController.target = center
        
        cameraNode.position = cameraPosition
        cameraNode.look(at: center)

    }
    
    init() {
        currentContentView = UIView()
        let accessoryView: UIView = UIView()
        
        super.init(title: "3D Assets",
                   contentView: currentContentView,
                   accessoryView: accessoryView
        )
        
        let stateSegmentedControl = UISegmentedControl(items: ["Normal",
                                                               "Highlighted",
                                                               "Selected",
                                                               "Disabled"])
        
        accessoryView.addSubview(stateSegmentedControl,
                                 withConstaintEquals: .marginEdges)
        
        stateSegmentedControl.addTarget(self,
                                        action: #selector(stateSegmentedControlValueChanged(_:)),
                                        for: .valueChanged)
        stateSegmentedControl.selectedSegmentIndex = 0
        setupScene()
        setupAvailableNodes()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        cameraNode.camera?.projectionDirection =
            rect.width > rect.height ? .vertical : .horizontal
    }
    
     override func setupStaticView() {
        super.setupStaticView()
        
        sceneView = SCNView(frame: .zero, options: [:])
        sceneView.backgroundColor = .clear
        sceneView.cameraControlConfiguration.allowsTranslation = false
        
        /// Set Antialiasing Mode depending on the density of the pixels, so if the screen is 3X, the view will use `multisampling2X` otherwise it will use `multisampling4X`
        sceneView.antialiasingMode = UIScreen.main.scale > 2 ?
            .multisampling2X : .multisampling4X
        
        currentContentView.addSubview(sceneView, withConstaintEquals: .edges)
        
        let arrowLeftButton = Button(type: .outlined)
        arrowLeftButton.setContentCompressionResistancePriority(.required, for: .horizontal)
        arrowLeftButton.setTitle("←")
        arrowLeftButton.addTarget(self, action: #selector(arrowLeftButtonDidTouch), for: .touchUpInside)
        
        let arrowRightButton = Button(type: .outlined)
        arrowRightButton.setContentCompressionResistancePriority(.required, for: .horizontal)
        arrowRightButton.setTitle("→")
        arrowRightButton.addTarget(self, action: #selector(arrowRightButtonDidTouch), for: .touchUpInside)
        
        nodeLabel = Label()
        nodeLabel.textStyle = textStyle.caption1()
        nodeLabel.textColor = currentColorTheme.componentColor.primaryText
        nodeLabel.adjustsFontSizeToFitWidth = true
        nodeLabel.minimumScaleFactor = 0.7
        
        let stackView = UIStackView([arrowLeftButton, nodeLabel, arrowRightButton],
                                    axis: .horizontal,
                                    distribution: .equalSpacing,
                                    alignment: .center,
                                    spacing: 16)
        
        currentContentView.addSubview(stackView, withConstaintEquals: [.leadingMargin, .bottomMargin, .trailingMargin])
        sceneView.preservesSuperviewLayoutMargins = true
        
        loadingIndicator.style = .whiteLarge
        loadingIndicator.color =  currentColorTheme.componentColor.secondaryText
        loadingIndicator.startAnimating()
        addSubview(loadingIndicator, withConstaintEquals: .safeAreaEdges, insetsConstant: .zero)
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        if let node = contentNode {
            
            // MARK: Add visual effect
            let tiltNodeMotionEffect = TiltNodeMotionEffect(node: node)
            
            tiltNodeMotionEffect.horizontalShiftedIntensity = 0
            tiltNodeMotionEffect.verticalShiftedIntensity = 0
            
            tiltNodeMotionEffect.horizontalTiltedIntensity = -1 / 2
            tiltNodeMotionEffect.verticalTiltedIntensity = 0
            
            superview?.addMotionEffect(tiltNodeMotionEffect)
        }
    }
    
    private func setupScene() {
        sceneView.scene = SCNScene()
        sceneView.scene?.background.contents = UIColor.clear
        sceneView.allowsCameraControl = true
        
        cameraNode = SCNNode()
        contentNode = SCNNode()
        
        let camera = SCNCamera()
        camera.fieldOfView = 45
        cameraNode.camera = camera
        sceneView.scene?.rootNode.addChildNode(cameraNode)
        sceneView.scene?.rootNode.addChildNode(contentNode)
        
    }
    
    private func setupAvailableNodes() {
        
        let decoder = JSONDecoder()
        if let data = NSDataAsset(name: "ModelData")?.data,
            let modelData = try? decoder.decode([ModelData].self, from: data) {
            factory = NodeFactory(modelData: modelData)
        } else {
            fatalError("There is some errors of trying to phrase JSON, so please check ModelData.json in Assets.xcassets")
        }
        
        if let factory = factory {
            
            let onComplete: () -> Void = { [weak self] in
                
                factory.modelPrototypes.keys
                    .forEach {
                    let reservableNode: InteractiveNode? =
                        factory.create(name: $0)
                    if let node = reservableNode{
                        self?.availableNodes.append(node)
                        self?.contentNode.addChildNode(node)
                    }
                }
                self?.availableNodes = self?.availableNodes.sorted(by: {$0.name ?? "" < $1.name ?? ""}) ?? []
                self?.currentNodeIndex = 0
                self?.loadingIndicator.removeFromSuperview()
            }
            if factory.isLoaded {
                DispatchQueue.global(qos: .background).async(execute: onComplete)
            }else{
                factory.onComplete(callback: onComplete)
            }
            
        }else{
            fatalError("NodeFactory is not defined before used")
        }
    }
    
    @objc func arrowLeftButtonDidTouch() {
        currentNodeIndex -= 1
    }
    
    @objc func arrowRightButtonDidTouch() {
        currentNodeIndex += 1
    }
    
    @objc func stateSegmentedControlValueChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            state = .normal
        case 1:
            state = .highlighted
        case 2:
            state = .selected
        case 3:
            state = .disabled
        default:
            break
        }
    }
}


