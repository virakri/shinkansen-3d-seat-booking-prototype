//
//  TrainCriteria.swift
//  Shinkansen Tickets Booking Prototype
//
//  Created by Nattawut Singhchai on 6/7/19.
//  Copyright © 2019 Virakri Jinangkul. All rights reserved.
//

import Foundation

struct TrainCriteria: Codable {
    let id: Int
    let fromStationJPName: String
    let fromStationName: String
    let toStationJPName: String
    let toStationName: String
    let date: Date
    let trainSchedules: [TrainSchedule]
}
