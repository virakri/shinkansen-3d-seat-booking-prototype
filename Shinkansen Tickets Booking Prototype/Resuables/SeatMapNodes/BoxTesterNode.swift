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
        self.geometry = SCNBox(width: 0.5, height: 0.5, length: 0.5, chamferRadius: 0.1)
        updateReservableEntity(reservableEntity: reservableEntity)
        setupTheme()
    }
    
    required init(geometry: SCNGeometry?, modelData: ModelData?) {
        super.init(geometry: geometry, modelData: modelData)
        if let geometry = geometry {
            self.geometry = geometry
        }else{
            self.geometry = SCNBox(width: 0.5, height: 0.5, length: 0.5, chamferRadius: 0.1)
        }
        setupTheme()
    }
    
    private var material: SCNMaterial? {
        return geometry?.firstMaterial
    }
    
    func updateReservableEntity(reservableEntity: ReservableEntity) {
        position = reservableEntity.transformedModelEntity.position
        eulerAngles = reservableEntity.transformedModelEntity.rotation
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
