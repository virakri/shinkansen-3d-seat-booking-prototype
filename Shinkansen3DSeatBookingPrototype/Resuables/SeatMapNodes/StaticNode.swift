//
//  ObjectNode.swift
//  Shinkansen 3D Seat Booking Prototype
//
//  Created by Nattawut Singhchai on 14/6/2019 .
//  Copyright © 2019 Virakri Jinangkul. All rights reserved.
//

import SceneKit

class StaticNode: SCNNode, Clonable {
    
    var materialMap: [String: Any] = [:]
    
    var isEnabled: Bool = true {
        didSet {
            updateMaterial(node: self, materialMap: materialMap)
        }
    }
    
    var transformedModelEntity: TransformedModelEntity? {
        didSet {
            guard let transformedModelEntity = transformedModelEntity else {
                return
            }
            position = transformedModelEntity.position
            eulerAngles = transformedModelEntity.rotation
        }
    }
    
    override init() {
        super.init()
    }
    
    required init(node: SCNNode) {
        super.init()
        addChildNode(node)
        materialMap = createMaterialMap(from: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    
    /// Update material from state
    /// - Parameter node: Target node to apply material
    /// - Parameter materialMap: Material map to apply for each state
    func updateMaterial(node: SCNNode, materialMap: [String: Any]) {
        if let materials = materialMap["materials"] as? [SCNMaterial] {
            node.geometry?.materials.forEach({ currentMaterial in
                if let name = currentMaterial.name?.appending("-\(isEnabled ? "normal" : "disabled")"),
                    let newMaterial = materials.first(where: { $0.name == name }) {
                    currentMaterial.clone(from: newMaterial)
                }else if let name = currentMaterial.name?.appending("-normal"),
                    let newMaterial = materials.first(where: { $0.name == name }) {
                    currentMaterial.clone(from: newMaterial)
                }else if let name = currentMaterial.name,
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
    
}
