//
//  ModelFactory.swift
//  Shinkansen Tickets Booking Prototype
//
//  Created by Nattawut Singhchai on 9/6/2562 BE.
//  Copyright © 2562 Virakri Jinangkul. All rights reserved.
//

import Foundation
import SceneKit
import BrightFutures

struct ModelData: Codable {
    let name: String
    let modelObject: URL
    let isInteractible: Bool
    
    let normal: ModelState
    let highlighted: ModelState
}

struct ModelState: Codable {
    let color: String
    let scale: CGFloat
}

protocol StaticNode {
    init(geometry: SCNGeometry?, modelData: ModelData)
    var isEnabled: Bool { get set }
}

protocol InteractibleNode: StaticNode {
    var isHighlighted: Bool { get set }
    var isSelected: Bool { get set }
}

class StateNode: SCNNode, InteractibleNode {
    
    var isHighlighted: Bool = false
    
    var isSelected: Bool = true
    
    var isEnabled: Bool = true
    
    let modelData: ModelData
    
    required init(geometry: SCNGeometry?, modelData: ModelData) {
        self.modelData = modelData
        super.init()
        self.geometry = geometry
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class NodeFactory {
    
    let url: URL
    
    var prototypeNode: SCNReferenceNode?
    
    var isLoaded = false
    
    private var onCompleted: ((NodeFactory) -> Void)?
    
    private var modelData: [ModelData]?
    
    private var modelPrototypes: [String: SCNReferenceNode] = [:]
    
    init(url: URL) {
        self.url = url
        fetchModelData(url).flatMap { [weak self] (modelData) -> Future<[String: SCNReferenceNode], Error> in
            guard let weakSelf = self else {
                return Future(error: NSError(domain: "NodeFactory", code: -9004, userInfo: [:]))
            }
            weakSelf.modelData = modelData
            let data = Dictionary(uniqueKeysWithValues: modelData.map { ($0.name, $0.modelObject) })
            return weakSelf.loadModels(from: data)
        }.onSuccess { modelPrototypes in
            self.isLoaded = true
            self.modelPrototypes = modelPrototypes
        }
    }
    
    private func fetchModelData(_ url: URL) -> Future<[ModelData], Error> {
        return Future { complete in
            URLSession().dataTask(with: url) { (data, response, error) in
                if let data = data {
                    let decoder = JSONDecoder()
                    let data = try? decoder.decode([ModelData].self, from: data)
                    DispatchQueue.main.async {
                        if let data = data {
                            complete(.success(data))
                        }else{
                            complete(.failure(NSError(
                                domain: "NodeFactory",
                                code: -9000,
                                userInfo: [NSLocalizedFailureReasonErrorKey: "Cannot decode json"])))
                        }
                    }
                }else if let error = error {
                    complete(.failure(error))
                }else{
                    complete(.failure(NSError(
                        domain: "NodeFactory",
                        code: -9001,
                        userInfo: [NSLocalizedFailureReasonErrorKey: "Something wrong"])))
                }
            }
        }
    }
    
    func loadModels(from data: [String: URL]) -> Future<[String: SCNReferenceNode], Error> {
        return data.map({ loadModel(name: $0, from: $1) })
            .sequence()
            .flatMap {
                Future(value: Dictionary(uniqueKeysWithValues: $0))
        }
    }
    
    func loadModel(name: String, from url: URL) -> Future<((String, SCNReferenceNode)), Error> {
        return Future { complete in
            DispatchQueue.global(qos: .background).async {
                if let node = SCNReferenceNode(url: url) {
                    node.load()
                    DispatchQueue.main.async {
                        complete(.success((name, node)))
                    }
                }else{
                    complete(.failure(NSError(domain: "NodeFactory",
                                              code: -9001,
                                              userInfo: [NSLocalizedFailureReasonErrorKey: "Something wrong"])))
                }
            }
        }
    }
    
    
    func create<T>(name: String) -> T? where T : SCNNode & StaticNode {
        guard
            let prototypeNode = prototypeNode,
            let modelData = modelData?.first(where: { $0.name == name }),
            prototypeNode.isLoaded
            else { return nil }
        return T(geometry: prototypeNode.geometry, modelData: modelData)
    }
    
    func create<T>(name: String, count: Int) -> [T] where T : SCNNode & StaticNode {
        return (1...count).compactMap { [weak self] _ in
            return self?.create(name: name)
        }
    }
    
}


