//
//  ModelData.swift
//  Shinkansen Tickets Booking Prototype
//
//  Created by Nattawut Singhchai on 19/6/2019 .
//  Copyright © 2019 Virakri Jinangkul. All rights reserved.
//

import SceneKit

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
