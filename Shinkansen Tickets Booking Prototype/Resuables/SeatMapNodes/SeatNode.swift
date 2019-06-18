//
//  BoxTesterNode.swift
//  Shinkansen Tickets Booking Prototype
//
//  Created by Virakri Jinangkul on 6/7/19.
//  Copyright © 2019 Virakri Jinangkul. All rights reserved.
//

import SceneKit

class SeatNode: ReservableNode {
    
    /// All states
    enum State: String, CodingKey {
        case normal, highlighted, selected, disabled, focus
    }
    
    /// setter-getter for hightlighted state
    override var isHighlighted: Bool {
        didSet {
            super.isHighlighted = isHighlighted
            setupTheme()
        }
    }
    
    /// setter-getter for selected state
    override var isSelected: Bool {
        didSet {
            super.isSelected = isSelected
            setupTheme()
        }
    }
    
    /// setter-getter for enabled/disabled state
    override var isEnabled: Bool {
        didSet {
            super.isEnabled = isEnabled
            setupTheme()
        }
    }
    
    /// getter for determine current state
    var state: State {
        return !isEnabled ?
                    .disabled:
                    isHighlighted ?
                        .highlighted:
                        isSelected ?
                            .selected :
                            .normal
    }
    
    /// Materials to apply for each state
    var materialMap: [String: Any] = [:]
    
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
    
    required init(node: SCNNode, modelData: ModelData?) {
        super.init(node: node, modelData: modelData)
        transformMapNode.transform = transform
        transformMapNode.addChildNode(removeAllGeomery(from: node.clone()))
        materialMap = createMaterialMap(from: self)
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
    private func updateMaterial(node: SCNNode, materialMap: [String: Any]) {
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
    
    /// Build material recursively map for `transformMapNode`
    /// - Parameter node: Target node to create
    private func createMaterialMap(from node: SCNNode) -> [String: Any] {
        var result = [String: Any]()
        if let materials = node.geometry?.materials {
            result["materials"] = materials.map { $0 }
        }
        
        let materialNames = node.geometry?.materials.compactMap { $0.name } ?? []
        
        // Filter dark/light mode
        node.geometry?.materials = node.geometry?.materials.compactMap({ material -> SCNMaterial? in
            if let name = material.name,
                let last = name.split(separator: "-").last,
                last == "darkMode" {
                var component = Array(name.split(separator: "-"))
                component.removeLast()
                let newName = component.joined(separator: "-")
                if currentColorTheme == .dark || (currentColorTheme != .dark && !materialNames.contains(newName)) {
                    material.name = newName
                    return material
                }
                return nil
            }else{
                if currentColorTheme == .dark && materialNames.contains( "\(material.name ?? "")-darkMode") {
                    return nil
                }else{
                    return material
                }
            }
        }).compactMap({ material  in
            // Material management
            if let name = material.name, name.contains("-") {
                var nameComponent = Array(name.split(separator: "-"))
                if let last = nameComponent.last,
                    let state = State(stringValue: String(last)),
                    nameComponent.count > 1
                {
                    if state == .normal {
                        nameComponent.removeLast()
                        let newName = nameComponent.joined(separator: "-")
                        return SCNMaterial().clone(from: material, name: newName)
                    }else{
                        return nil
                    }
                }
            }
            return material
        }) ?? []
        node.childNodes.forEach { child in
            result[child.name ?? "undefined"] = createMaterialMap(from: child)
        }
        return result
    }
    
}

// MARK:- Extension

extension SeatNode.State: Equatable {
    static func == (lhs: String, rhs: SeatNode.State) -> Bool {
        return lhs == rhs.stringValue
    }
    static func == (lhs: SeatNode.State, rhs: String) -> Bool {
        return lhs.stringValue == rhs
    }
}
