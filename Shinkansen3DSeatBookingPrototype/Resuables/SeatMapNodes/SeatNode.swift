//
//  BoxTesterNode.swift
//  Shinkansen 3D Seat Booking Prototype
//
//  Created by Virakri Jinangkul on 6/7/19.
//  Copyright © 2019 Virakri Jinangkul. All rights reserved.
//

import SceneKit

/// All states
enum State: String, CodingKey {
    case normal, highlighted, selected, disabled, focus
}

class SeatNode: InteractiveNode {
    
    
    
    private var state: State = .normal
    
    /// setter-getter for hightlighted state
    override var isHighlighted: Bool {
        didSet {
            super.isHighlighted = isHighlighted
            reloadState()
        }
    }
    
    /// setter-getter for selected state
    override var isSelected: Bool {
        didSet {
            super.isSelected = isSelected
            reloadState()
        }
    }
    
    /// setter-getter for enabled/disabled state
    override var isEnabled: Bool {
        get {
            return super.isEnabled
        }set {
            super.isEnabled = newValue
            reloadState()
        }
    }
    
    private func reloadState(_ animated: Bool = true) {
        let newState: State = !isEnabled ?
                    .disabled:
                    isHighlighted ?
                        .highlighted:
                    isSelected ?
                        .selected :
                    .normal
        
        if newState != state {
            state = newState
            setupTheme(animated)
        }
    }
    
    
    func setEnabled(_ isEnabled: Bool, animated: Bool) {
        if animated {
            self.isEnabled = isEnabled
        }else{
            super.isEnabled = isEnabled
            reloadState()
        }
    }
    
    // MARK:- Variables
    
    /// Stored original transform
    let transformMapNode = SCNNode()
    
    /// Current node's entity information
    override var reservableEntity: ReservableEntity? {
        didSet {
            super.reservableEntity = reservableEntity
            if let reservableEntity = reservableEntity {
                updateReservableEntity(reservableEntity: reservableEntity)
            }
        }
    }
    
    // MARK: Intialializer
    
    required init(node: SCNNode) {
        super.init(node: node)
        name = node.name
        transformMapNode.transform = transform
        transformMapNode.addChildNode(removeAllGeomery(from: node.clone()))
        setupTheme(false)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Node Setup
    
    /// Change material and transform for each state
    private func setupTheme(_ animated: Bool = true) {
        if animated {
            SceneKitAnimator.animateWithDuration(duration: 0.35 / 4, animations: {
                updateMaterial(node: self, materialMap: materialMap)
                updateTransfrom(node: self.childNodes[0], transformMapNode: transformMapNode.childNodes[0])
            })
        }else{
            updateMaterial(node: self, materialMap: materialMap)
            updateTransfrom(node: self.childNodes[0], transformMapNode: transformMapNode.childNodes[0])
        }
    }
    
    /// Function to update transform from `reservableEntity`
    /// - Parameter reservableEntity: Target tranfrom data
    private func updateReservableEntity(reservableEntity: ReservableEntity) {
        position = reservableEntity.transformedModelEntity.position
        eulerAngles = reservableEntity.transformedModelEntity.rotation
    }
    
    /// Update material from state
    /// - Parameter node: Target node to apply material
    /// - Parameter materialMap: Material map to apply for each state
    override func updateMaterial(node: SCNNode, materialMap: [String: Any]) {
        if let materials = materialMap["materials"] as? [SCNMaterial] {
            node.geometry?.materials.forEach({ currentMaterial in
                if let name = currentMaterial.name?.appending("-\(state.stringValue)"),
                    let newMaterial = materials.first(where: { $0.name == name }) {
                    currentMaterial.clone(from: newMaterial)
                }else if let name = currentMaterial.name?.appending("-\(State.normal.stringValue)"),
                    let newMaterial = materials.first(where: { $0.name == name }) {
                    currentMaterial.clone(from: newMaterial)
                }
            })
        }
        node.childNodes.forEach { child in
            if let map = materialMap[child.name ?? "undefined"] as? [String: Any] {
                updateMaterial(node: child, materialMap: map)
            }
        }
    }
    
    /// Function for update node's transform from `transformMapNode`
    /// - Parameter node: Target node to apply transform
    /// - Parameter transformMapNode: Map node that contained each state's transform
    private func updateTransfrom(node: SCNNode, transformMapNode: SCNNode) {
        if let parent = node.parent {
            node.transform = SCNMatrix4Identity
            node.transform = parent.convertTransform(transformMapNode.transform, from: node)
            if let childNode = transformMapNode.childNode(withName: state.stringValue, recursively: false) {
                node.transform = node.parent!.convertTransform(childNode.transform, from: node)
            }
        }
        
        zip(node.childNodes, transformMapNode.childNodes).forEach {
            updateTransfrom(node: $0, transformMapNode: $1)
        }
    }
    
    // MARK: Utility
    
    /// Function for remove all geometry from node
    /// - Parameter node: Target node to remove geometry
    @discardableResult
    private func removeAllGeomery(from node: SCNNode) -> SCNNode {
        node.geometry = nil
        node.childNodes.forEach { removeAllGeomery(from: $0) }
        return node
    }
    
    
}

// MARK:- Extension

extension State: Equatable {
    static func == (lhs: String, rhs: State) -> Bool {
        return lhs == rhs.stringValue
    }
    static func == (lhs: State, rhs: String) -> Bool {
        return lhs.stringValue == rhs
    }
}
