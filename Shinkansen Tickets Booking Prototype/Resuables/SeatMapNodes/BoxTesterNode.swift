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
    
    enum State: String, CodingKey, Equatable {
        case normal, highlighted, disabled, focus
        
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
    
    func updateMaterial(node: SCNNode, materialMap: [String: Any]) {
        
        let state: State = isHighlighted ? .highlighted: .normal
        
        if let materials = materialMap["materials"] as? [SCNMaterial] {
            node.geometry?.materials.forEach({ currentMaterial in
                if let name = currentMaterial.name?.appending("-\(state.stringValue)"),
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
    
    func updateTransfrom(node: SCNNode) {
        
        let state: State = isHighlighted ? .highlighted : .normal
        
        if let childNode = node.childNode(withName: state.stringValue, recursively: false) {
//            a.tranfrom = a.parent.convertTransform(b.transform, from: b.parent)
            
            let tempTransform = node.transform
            node.transform = node.parent!.convertTransform(childNode.transform, from: node)
//                .convertTransform(childNode.transform, from: node)
        }
        
        node.childNodes.forEach { node in
            updateTransfrom(node: node)
        }
    }
    
    func setupTheme() {
        updateMaterial(node: self, materialMap: materialMap)
        updateTransfrom(node: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
