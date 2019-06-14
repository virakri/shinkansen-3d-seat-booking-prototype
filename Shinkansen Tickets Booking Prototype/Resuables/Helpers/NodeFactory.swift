//
//  NodeFactory.swift
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
    let resource: ModelData.Resource
    let isInteractible: Bool
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ModelDataKey.self)
        self.name = try container.decode(String.self, forKey: .name)
        if let string = try? container.decode(String.self, forKey: .resource) {
            if let _ = URL.resource(name: string) {
                self.resource = .fileName(string)
            }else if let url = URL(string: string) {
                self.resource = .url(url)
            }else{
                self.resource = .none
            }
        }else{
            self.resource = .none
        }
        self.isInteractible = try container.decode(Bool.self, forKey: .isInteractible)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: ModelDataKey.self)
        try container.encode(name, forKey: .name)
        try container.encode(resource.encode(), forKey: .resource)
        try container.encode(isInteractible, forKey: .isInteractible)
    }
    
    enum Resource {
        case url(URL)
        case fileName(String)
        case none
        
        func encode() -> String? {
            switch self {
            case .url(let url):
                return url.absoluteString
            case .fileName(let name):
                return name
            default:
                return nil
            }
        }
    }
    
    enum ModelDataKey: String, CodingKey {
        case name, resource, isInteractible
    }
}

protocol StaticNode {
    init(node: SCNNode, modelData: ModelData?)
    var isEnabled: Bool { get set }
}

protocol InteractibleNode: StaticNode {
    var isHighlighted: Bool { get set }
    var isSelected: Bool { get set }
}

class NodeFactory {
    
    static var shared: NodeFactory?
    
    var url: URL!
    
    var isLoaded = false {
        didSet {
            onFactoryLoadedCompletionBuffer.forEach { (callback) in
                callback(self)
            }
        }
    }
    
    private var onCompleted: ((NodeFactory) -> Void)?
    
    private var modelData: [ModelData]?
    
    var modelPrototypes: [String: SCNNode?] = [:]
    
    private var onFactoryLoadedCompletionBuffer: [(NodeFactory) -> Void] = []
    
    func onComplete(callback: @escaping (NodeFactory) -> Void) {
        onFactoryLoadedCompletionBuffer.append(callback)
    }
    
    init(url: URL) {
        self.url = url
        loadNodeFrom(fetchModelData(url))
    }
    
    init(modelData: [ModelData]) {
        loadNodeFrom(Future(value: modelData))
    }
    
    private func loadNodeFrom(_ future: Future<[ModelData], Error>) {
        future.flatMap { [weak self] (modelData) -> Future<[String: SCNNode?], Error> in
            guard let weakSelf = self else {
                return Future(error: NSError(
                    domain: "NodeFactory",
                    code: -9004, userInfo: [NSLocalizedFailureReasonErrorKey: "Memory of self release before use it"]
                ))
            }
            weakSelf.modelData = modelData
            return weakSelf.loadModels(
                from: Dictionary(
                    uniqueKeysWithValues: modelData.compactMap {
                        switch $0.resource {
                        case .fileName(let filename):
                            return ($0.name, URL.resource(name: filename)) as? (String, URL)
                        case .url(let url):
                            return ($0.name, url)
                        default:
                            return nil
                        }
                    }
                )
            )
            }.onSuccess { modelPrototypes in
                self.modelPrototypes = modelPrototypes
                self.isLoaded = true
            }.onFailure { error in
                print(error)
        }
    }
    
    private func fetchModelData(_ url: URL) -> Future<[ModelData], Error> {
        return Future { complete in
            URLSession.shared.dataTask(with: url) { (data, response, error) in
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
            }.resume()
        }
    }
    
    func loadModels(from data: [String: URL]) -> Future<[String: SCNNode?], Error> {
        return data.map({ loadModel(name: $0, from: $1) })
            .sequence()
            .flatMap {
                Future(value: Dictionary(uniqueKeysWithValues: $0))
        }
    }
    
    func loadModel(name: String, from url: URL) -> Future<((String, SCNNode?)), Error> {
        return Future { complete in
            DispatchQueue.global(qos: .background).async {
                if let node = SCNReferenceNode(url: url) {
                    node.load()
                    DispatchQueue.main.async {
                        complete(
                            .success(
                                (name, node.childNodes.first )
                            )
                        )
                    }
                }else{
                    complete(.failure(NSError(domain: "NodeFactory",
                                              code: -9001,
                                              userInfo: [NSLocalizedFailureReasonErrorKey: "URL of model seems wrong"])))
                }
            }
        }
    }
    
    func create<T>(name: String) -> T? where T : SCNNode & StaticNode {
        guard
            let prototypeNode = modelPrototypes[name] as? SCNNode,
            let modelData = modelData?.first(where: { $0.name == name })
            else { return nil }
        
        let clone = prototypeNode.clone()
        
        func cloneGeometry(from: SCNNode, to: SCNNode) {
            to.geometry = from.geometry?.copy() as? SCNGeometry
            to.geometry?.materials = from.geometry?.materials.map {
                SCNMaterial().clone(from: $0, name: $0.name)
                } ?? []
            if modelData.isInteractible {
                to.categoryBitMask = ReservableNode.defaultBitMask
            }
            zip(from.childNodes, to.childNodes).forEach {
                cloneGeometry(from: $0, to: $1)
            }
        }
        
        cloneGeometry(from: prototypeNode, to: clone)
        
        let node = T(
            node: clone,
            modelData: modelData
        )

        return node
    }
    
    func create<T>(name: String, count: Int) -> [T] where T : SCNNode & StaticNode {
        return (1...count).compactMap { [weak self] _ in
            return self?.create(name: name)
        }
    }
    
}
