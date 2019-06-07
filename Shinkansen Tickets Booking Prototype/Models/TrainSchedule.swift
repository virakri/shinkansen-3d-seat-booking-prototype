//
//  TrainSchedule.swift
//  Shinkansen Tickets Booking Prototype
//
//  Created by Nattawut Singhchai on 6/7/19.
//  Copyright © 2019 Virakri Jinangkul. All rights reserved.
//

import Foundation

struct TrainSchedule: Codable {
    let id: Int
    let fromTime: Date
    let toTime: Date
    let trainNumber: String
    let trainName: String
    let trainImageName: String
    let seatClasses: [SeatClass]
}
