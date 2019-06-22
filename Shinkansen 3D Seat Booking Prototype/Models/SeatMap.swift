//
//  SeatMap.swift
//  Shinkansen 3D Seat Booking Prototype
//
//  Created by Nattawut Singhchai on 6/7/19.
//  Copyright © 2019 Virakri Jinangkul. All rights reserved.
//

import Foundation
import SceneKit

typealias ModelEntity = String

struct SeatMap: Decodable {
    let id: Int
    let name: String
    let seatClassEntities: [SeatClassEntity]
    let transformedModelEntities: [TransformedModelEntity]
    let transformedTextModelEntities: [TextNode]
}
