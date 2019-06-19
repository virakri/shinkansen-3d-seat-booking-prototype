//
//  SeatClassEntity.swift
//  Shinkansen Tickets Booking Prototype
//
//  Created by Nattawut Singhchai on 19/6/2019 .
//  Copyright © 2019 Virakri Jinangkul. All rights reserved.
//

import SceneKit

class SeatClassEntity: Codable {
    let id: Int
    let seatClass: SeatClassType
    let name: String
    let carNumber: String
    let reservableEntities: [ReservableEntity]
    let viewableRange: ClosedRange<SCNVector3>
    let transformedModelEntities: [TransformedModelEntity]
}

