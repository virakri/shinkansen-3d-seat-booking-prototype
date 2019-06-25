//
//  SeatClassEntity.swift
//  Shinkansen 3D Seat Booking Prototype
//
//  Created by Nattawut Singhchai on 6/7/19.
//  Copyright © 2019 Virakri Jinangkul. All rights reserved.
//

import SceneKit

enum SeatClassType: String, Codable {
    case granClass = "granClass"
    case green = "green"
    case ordinary = "ordinary"
}

struct SeatClass: Codable {
    let id: Int
    let name: String
    let description: String
    let seatClass: SeatClassType
    let price: Float
    let isAvailable: Bool
}

extension SeatClassType {
    var name: String {
        switch self {
        case .granClass:
            return "Gran Class"
        case .green:
            return "Green Class"
        case .ordinary:
            return "Ordinary Class"
        }
    }
    
    var completeNodeName: String {
        switch self {
        case .granClass:
            return "_e7_gran_seat_complete"
        case .green:
            return "_e7_green_seat_complete"
        case .ordinary:
            return "_e7_ordinary_seat_complete"
        }
    }
}
