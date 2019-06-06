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
    
    init() {
        super.init(frame: .zero, options: nil)
        backgroundColor = .clear
        
        // Temporary
        
        let scene = SCNScene()
        
        let box = SCNBox(width: 3.380, height: 3.650, length: 25.000, chamferRadius: 0.1)
        box.firstMaterial?.diffuse.contents = UIColor.gray
        let boxNode = SCNNode(geometry: box)
        
        // Camera
        let camera = SCNCamera()
        let cameraNode = SCNNode()
        cameraNode.camera = camera
        
        scene.rootNode.addChildNode(boxNode)
        
        self.scene = scene
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class SeatMapView: UIView {
    
    var seatMapSceneView: SeatMapSceneView!
    
    init() {
        seatMapSceneView = SeatMapSceneView()
        super.init(frame: .zero)
        setupView()
    }
    
    private func setupView() {
        addSubview(seatMapSceneView, withConstaintEquals: .edges)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
