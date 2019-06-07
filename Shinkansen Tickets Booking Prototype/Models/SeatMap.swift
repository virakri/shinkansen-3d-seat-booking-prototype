//
//  SeatMap.swift
//  Shinkansen Tickets Booking Prototype
//
//  Created by Nattawut Singhchai on 6/7/19.
//  Copyright © 2019 Virakri Jinangkul. All rights reserved.
//

import Foundation
import SceneKit

typealias ModelEntity = String

struct SeatMap: Codable {
    let id: Int
    let name: String
    let seatClassEntities: [SeatClassEntity]
    let transformedModelEntity: TransformedModelEntity
}
