//
//  SeatClassEntity.swift
//  Shinkansen Tickets Booking Prototype
//
//  Created by Nattawut Singhchai on 6/7/19.
//  Copyright © 2019 Virakri Jinangkul. All rights reserved.
//

import SceneKit

enum SeatClass: String, Codable {
    case granClass = "granClass"
    case green = "green"
    case ordinary = "ordinary"
}

struct SeatClassEntity: Codable {
    let id: Int
    let seatClass: SeatClass
    let name: String
    let carNumber: String
    let reservableEntities: [ReservableEntity]
    let viewableRange: ClosedRange<SCNVector3>
    let transformedModelEntity: TransformedModelEntity
}
