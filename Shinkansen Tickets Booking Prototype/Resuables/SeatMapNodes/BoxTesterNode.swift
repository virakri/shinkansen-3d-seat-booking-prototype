//
//  BoxTesterNode.swift
//  Shinkansen Tickets Booking Prototype
//
//  Created by Virakri Jinangkul on 6/7/19.
//  Copyright © 2019 Virakri Jinangkul. All rights reserved.
//

import SceneKit

class BoxTesterNode: ReservableNode {
    
    override var isHighlighted: Bool {
        didSet {
            super.isHighlighted = isHighlighted
            setupTheme()
        }
    }
    
    override init(reservableEntity: ReservableEntity) {
        super.init(reservableEntity: reservableEntity)
        
        let box = SCNBox(width: 0.5, height: 0.5, length: 0.5, chamferRadius: 0.1)
        geometry = box
        position = reservableEntity.transformedModelEntity.position
        eulerAngles = reservableEntity.transformedModelEntity.rotation
        setupTheme()
    }
    
    private var material: SCNMaterial? {
        return geometry?.firstMaterial
    }
    
    func setupTheme() {
        
        material?.diffuse.contents = UIColor.yellow
        
        if self.isHighlighted {
            material?.diffuse.contents = UIColor.red
        }
        
        if self.isSelected {
            material?.diffuse.contents = UIColor.yellow
        }
        
        if !self.isEnabled {
            material?.diffuse.contents = UIColor.gray
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
