//
//  TransformedModelEntity.swift
//  Shinkansen Tickets Booking Prototype
//
//  Created by Nattawut Singhchai on 6/7/19.
//  Copyright © 2019 Virakri Jinangkul. All rights reserved.
//

import SceneKit

struct TransformedModelEntity: Codable {
    let modelEntity: ModelEntity
    let position: SCNVector3
    let rotation: SCNVector3
}
