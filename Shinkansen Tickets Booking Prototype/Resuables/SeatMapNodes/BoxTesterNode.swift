//
//  BoxTesterNode.swift
//  Shinkansen Tickets Booking Prototype
//
//  Created by Virakri Jinangkul on 6/7/19.
//  Copyright © 2019 Virakri Jinangkul. All rights reserved.
//

import SceneKit

class BoxTesterNode: ReservableNode {
    
    var materialMap: [String: Any] = [:]
    
    let transformMapNode = SCNNode()
    
    enum State: String, CodingKey, Equatable {
        case normal, highlighted, selected, disabled, focus
        
        static func == (lhs: String, rhs: State) -> Bool {
            return lhs == rhs.stringValue
        }
        
        static func == (lhs: State, rhs: String) -> Bool {
            return lhs.stringValue == rhs
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            super.isHighlighted = isHighlighted
            print("\(reservableEntity?.name ?? "-") = \(isHighlighted)")
            setupTheme()
        }
    }
    
    override var isSelected: Bool {
        didSet {
            super.isSelected = isSelected
            setupTheme()
        }
    }
    
    override var reservableEntity: ReservableEntity? {
        didSet {
            super.reservableEntity = reservableEntity
            if let reservableEntity = reservableEntity {
                updateReservableEntity(reservableEntity: reservableEntity)
            }
        }
    }
    
    override init(reservableEntity: ReservableEntity) {
        super.init(reservableEntity: reservableEntity)
        self.geometry = SCNBox(width: 0.5, height: 0.5, length: 0.5, chamferRadius: 0.1)
        updateReservableEntity(reservableEntity: reservableEntity)
        setupTheme()
    }
    
    required init(node: SCNNode, modelData: ModelData?) {
        super.init(node: node, modelData: modelData)
        transformMapNode.transform = transform
        transformMapNode.addChildNode(removeAllGeomery(from: node.clone()))
        
        func createMaterialMap(from node: SCNNode) -> [String: Any] {
            var result = [String: Any]()
            if let materials = node.geometry?.materials {
                result["materials"] = materials.map { $0 }
            }

            node.geometry?.materials = node.geometry?.materials.compactMap({ material  in
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
        
        materialMap = createMaterialMap(from: self)
        setupTheme()
    }
    
    private var material: SCNMaterial? {
        return geometry?.firstMaterial
    }
    
    private func updateReservableEntity(reservableEntity: ReservableEntity) {
        position = reservableEntity.transformedModelEntity.position
        eulerAngles = reservableEntity.transformedModelEntity.rotation
    }
    
    @discardableResult
    private func removeAllGeomery(from node: SCNNode) -> SCNNode {
        node.geometry = nil
        node.childNodes.forEach { removeAllGeomery(from: $0) }
        return node
    }
    
    func updateMaterial(node: SCNNode, materialMap: [String: Any]) {
        
        let state: State =  isHighlighted ? .highlighted: isSelected ? .selected : .normal
        
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
    
    func updateTransfrom(node: SCNNode, transformMapNode: SCNNode) {
        
        let state: State =  isHighlighted ? .highlighted: isSelected ? .selected : .normal
        
        if let childNode = transformMapNode.childNode(withName: state.stringValue, recursively: false) {
            node.transform = SCNMatrix4Identity
            node.transform = node.parent!.convertTransform(transformMapNode.transform, from: node)
            node.transform = node.parent!.convertTransform(childNode.transform, from: node)
        }else{
            node.transform = SCNMatrix4Identity
            node.transform = node.parent!.convertTransform(transformMapNode.transform, from: node)
        }
        
        zip(node.childNodes, transformMapNode.childNodes).forEach {
            updateTransfrom(node: $0, transformMapNode: $1)
        }
        
    }
    
    func setupTheme() {
        SceneKitAnimator.animateWithDuration(duration: 0.35 / 4, animations: {
            updateMaterial(node: self, materialMap: materialMap)
            updateTransfrom(node: self.childNodes[0], transformMapNode: transformMapNode.childNodes[0])
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
