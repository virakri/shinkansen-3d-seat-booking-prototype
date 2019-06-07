//
//  BoxTesterNode.swift
//  Shinkansen Tickets Booking Prototype
//
//  Created by Virakri Jinangkul on 6/7/19.
//  Copyright © 2019 Virakri Jinangkul. All rights reserved.
//

import SceneKit

class BoxTesterNode: ReservableNode {
    
    var isHighlighted: Bool = false
    
    var isSelected: Bool = false
    
    var isEnabled: Bool = true
    
    override init(reservableEntity: ReservableEntity) {
        super.init(reservableEntity: reservableEntity)
        
        let box = SCNBox(width: 0.5, height: 0.5, length: 0.5, chamferRadius: 0.1)
        geometry = box
        position = reservableEntity.transformedModelEntity.position
        eulerAngles = reservableEntity.transformedModelEntity.rotation
        setupTheme()
    }
    
    func setupTheme() {
        let material = geometry?.firstMaterial
        
        material?.diffuse.contents = UIColor.yellow
        
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
