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

protocol StaticNode {
    init(node: SCNNode, modelData: ModelData?)
    var isEnabled: Bool { get set }
}

protocol InteractibleNode: StaticNode {
    var isHighlighted: Bool { get set }
    var isSelected: Bool { get set }
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
        loadNodeFrom(fetchModelData(url))
    }
    
    public init(modelData: [ModelData]) {
        loadNodeFrom(Future(value: modelData))
    }
    
    /// Chained method to work after `[ModelData]` are generated
    /// - Parameter future: `[ModelData]` future object
    private func loadNodeFrom(_ future: Future<[ModelData], Error>) {
        // flatmap (convert) [ModelData] to [String: SCNNode?]
        future.flatMap { [weak self] (modelData) -> Future<[String: SCNNode?], Error> in
            guard let weakSelf = self else {
                return Future(error: NSError(
                    domain: "NodeFactory",
                    code: -9004, userInfo: [NSLocalizedFailureReasonErrorKey: "Memory of self release before use it"]
                ))
            }
            weakSelf.modelData = modelData
            // Load each model from model data
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
            // When all models are loaded store it to `modelPrototypes` and notify user by set isLoaded = true
            }.onSuccess { [weak self] modelPrototypes in
                self?.modelPrototypes = modelPrototypes
                self?.isLoaded = true
            }.onFailure { error in
                print(error)
        }
    }
    
    
    /// Fetch model data from URL
    /// - Parameter url: URL that contain json of `[ModelData]`
    private func fetchModelData(_ url: URL) -> Future<[ModelData], Error> {
        // return it as Future of `[ModelData]`
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
    
    
    /// Load all models by sequency
    /// - Parameter data: String = refernced key of model, URL = url of `*.scn` file
    public func loadModels(from data: [String: URL]) -> Future<[String: SCNNode?], Error> {
        return data.map({ loadModel(name: $0, from: $1) })
            .sequence()
            .flatMap {
                Future(value: Dictionary(uniqueKeysWithValues: $0))
        }
    }
    
    
    /// Load model (*.scn file) from url
    /// - Parameter name: Refernced key of mode
    /// - Parameter url: URL of `*.scn` file
    public func loadModel(name: String, from url: URL) -> Future<((String, SCNNode?)), Error> {
        /// returns pair of String, SCNNode
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
    
    /// After models are loaded this function allow to create model from refferenced name
    /// by provoide generic object that conform to `StaticNode` protocol
    /// - Parameter name: Refferenced name of prototype node
    public func create<T>(name: String) -> T? where T : SCNNode & StaticNode {
        guard
            let prototypeNode = modelPrototypes[name] as? SCNNode,
            let modelData = modelData?.first(where: { $0.name == name })
            else { return nil }
        
        let clone = prototypeNode.clone()
        
        /// Deep clone new geometry from prototype recursively
        func cloneGeometry(from: SCNNode, to: SCNNode) {
            to.geometry = from.geometry?.copy() as? SCNGeometry
            if modelData.isInteractible {
                to.categoryBitMask = ReservableNode.defaultBitMask
            }
            zip(from.childNodes, to.childNodes).forEach {
                cloneGeometry(from: $0, to: $1)
            }
        }
        
        cloneGeometry(from: prototypeNode, to: clone)
        
        // Create node object from provioded generic
        let node = T(
            node: clone,
            modelData: modelData
        )

        return node
    }
    
}
