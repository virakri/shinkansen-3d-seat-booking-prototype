//
//  ReservableEntity.swift
//  Shinkansen 3D Seat Booking Prototype
//
//  Created by Nattawut Singhchai on 6/7/19.
//  Copyright © 2019 Virakri Jinangkul. All rights reserved.
//

import Foundation

struct ReservableEntity: Codable {
    let id: Int
    let name: String
    let carNumber: String
    let isAvailable: Bool
    let transformedModelEntity: TransformedModelEntity
}
