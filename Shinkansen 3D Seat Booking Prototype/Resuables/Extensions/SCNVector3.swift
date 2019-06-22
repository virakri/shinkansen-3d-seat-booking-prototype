//
//  SCNVector3.swift
//  Shinkansen 3D Seat Booking Prototype
//
//  Created by Nattawut Singhchai on 6/7/19.
//  Copyright © 2019 Virakri Jinangkul. All rights reserved.
//

import SceneKit

extension SCNVector3: Codable {
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let x = try values.decode(Float.self, forKey: .x)
        let y = try values.decode(Float.self, forKey: .y)
        let z = try values.decode(Float.self, forKey: .z)
        self.init(x, y, z)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(x, forKey: .x)
        try container.encode(y, forKey: .y)
        try container.encode(z, forKey: .z)
    }
    
    private enum CodingKeys: String, CodingKey {
        case x,y,z
    }
    
    static var zero: SCNVector3 {
        return SCNVector3(0, 0, 0)
    }
}

extension SCNVector3: Comparable {
    public static func < (lhs: SCNVector3, rhs: SCNVector3) -> Bool {
        // Fix this logic
        return lhs.x < rhs.x
    }
    
    public static func == (lhs: SCNVector3, rhs: SCNVector3) -> Bool {
        return SCNVector3EqualToVector3(lhs, rhs);
    }
}
