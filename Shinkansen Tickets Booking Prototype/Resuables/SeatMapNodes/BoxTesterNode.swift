//
//  BoxTesterNode.swift
//  Shinkansen Tickets Booking Prototype
//
//  Created by Virakri Jinangkul on 6/7/19.
//  Copyright © 2019 Virakri Jinangkul. All rights reserved.
//

import SceneKit

class BoxTesterNode: SCNNode {
    
    var isHighlighted: Bool = false
    
    var isSelected: Bool = false
    
    var isEnabled: Bool = true
    
    override init() {
        super.init()
        
        let box = SCNBox(width: 0.5, height: 0.5, length: 0.5, chamferRadius: 0.1)
        geometry = box
        
        setupTheme()
    }
    
    func setupTheme() {
        let material = geometry?.firstMaterial
        
        material?.diffuse.contents = UIColor.white
        
        if isHighlighted {
            material?.diffuse.contents = UIColor.red
        }
        
        if isSelected {
            material?.diffuse.contents = UIColor.yellow
        }
        
        if !isEnabled {
            material?.diffuse.contents = UIColor.gray
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
