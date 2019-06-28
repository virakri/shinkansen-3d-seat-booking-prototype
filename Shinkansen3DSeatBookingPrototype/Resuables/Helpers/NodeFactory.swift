//
//  NodeFactory.swift
//  Shinkansen 3D Seat Booking Prototype
//
//  Created by Nattawut Singhchai on 9/6/2562 BE.
//  Copyright © 2562 Virakri Jinangkul. All rights reserved.
//

import Foundation
import SceneKit
import BrightFutures

public protocol NodeFactoryCreatable {
    init(node: SCNNode)
}

final class NodeFactory {
    
    static public var shared: NodeFactory?
    
    public var url: URL!
    
    public var isLoaded = false {
        didSet {
            // When all models are loaded, This method will execute all completion block.
            onFactoryLoadedCompletionBuffer.forEach { (callback) in
                callback()
            }
        }
    }
    
    private var modelData: [ModelData]?
    
    public var modelPrototypes: [String: SCNNode?] = [:]
    
    private var onFactoryLoadedCompletionBuffer: [() -> Void] = []
    
    /// Ge callback when all models are loaded
    /// - Parameter callback: Command to execute after models are loaded
    public func onComplete(callback: @escaping () -> Void) {
        onFactoryLoadedCompletionBuffer.append(callback)
    }
    
    public init(url: URL) {
        self.url = url
        fetchModelData(url)
            .flatMap{ self.loadNode(from: $0) }
            .onComplete(callback: finalizeData)
    }
    
    public init(modelData: [ModelData]) {
        loadNode(from: modelData)
            .onComplete(callback: finalizeData)
    }
    
    /// if proviode URL let fetch model data from URL first
    /// - Parameter url: URL that contain json of `[ModelData]`
    private func fetchModelData(_ url: URL) -> Future<[ModelData], Error> {
        // return it as Future of `[ModelData]`
        return Future { complete in
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let data = data {
                    let decoder = JSONDecoder()
                    do {
                        let response = try decoder.decode([ModelData].self, from: data)
                        complete(.success(response))
                    } catch (let error) {
                        complete(.failure(error))
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
    
    
    /// Chained method to work after `[ModelData]` are generated
    /// - Parameter future: `[ModelData]` future object
    private func loadNode(from modelData: [ModelData]) -> Future<[String: SCNNode?], Error> {
        self.modelData = modelData
        return loadModels(
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
    }
    
    /// Load all models by sequency
    /// - Parameter data: String = refernced key of model, URL = url of `*.scn` file
    public func loadModels(from data: [String: URL]) -> Future<[String: SCNNode?], Error> {
        return data.map({ loadModel(name: $0, from: $1) })
            .sequence()
            .map { Dictionary(uniqueKeysWithValues: $0) }
    }
    
    
    /// Load model (*.scn file) from url
    /// - Parameter name: Refernced key of mode
    /// - Parameter url: URL of `*.scn` file
    public func loadModel(name: String, from url: URL) -> Future<((String, SCNNode?)), Error> {
        /// returns pair of String, SCNNode
        return Future { [weak self] complete in
            DispatchQueue.global(qos: .background).async {
                if let node = SCNReferenceNode(url: url) {
                    node.load()
                    if let modelData = self?.modelData?.first(where: {$0.name == name}),
                        modelData.isInteractible{
                        self?.applyInteractiveCategoryBitmask(to: node)
                    }
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
    
    private func finalizeData(_ result: Result<[String: SCNNode?], Error>) {
        switch result {
        case .success(let modelPrototypes):
            self.modelPrototypes = modelPrototypes
            self.isLoaded = true
        case .failure(let error):
            print(error)
        }
    }
    
    // MARK:- Create new node from prototype

    
    /// After models are loaded this function allow to create model from refferenced name
    /// by provoide generic object that conform to `StaticNode` protocol
    /// - Parameter name: Refferenced name of prototype node
    public func create<T>(name: String) -> T? where T:  NodeFactoryCreatable {
        guard let prototypeNode = modelPrototypes[name] as? SCNNode else {
            return nil
        }
        
        let clone = prototypeNode.clone()
        
        /// Deep clone new geometry from prototype recursively
        func cloneGeometry(from: SCNNode, to: SCNNode) {
            to.geometry = from.geometry?.copy() as? SCNGeometry
            zip(from.childNodes, to.childNodes).forEach {
                cloneGeometry(from: $0, to: $1)
            }
        }
        
        cloneGeometry(from: prototypeNode, to: clone)
        
        // Create node object from provioded generic
        let node = T(node: clone)
        
        return node
    }
    
    /// Apply interactive cateogry bitmask
    private func applyInteractiveCategoryBitmask(to node: SCNNode) {
        node.categoryBitMask = InteractiveNode.defaultBitMask
        for node in node.childNodes {
            applyInteractiveCategoryBitmask(to: node)
        }
    }
    
}
