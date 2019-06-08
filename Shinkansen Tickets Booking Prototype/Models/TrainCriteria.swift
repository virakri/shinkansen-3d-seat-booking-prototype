//
//  TrainCriteria.swift
//  Shinkansen Tickets Booking Prototype
//
//  Created by Nattawut Singhchai on 6/7/19.
//  Copyright © 2019 Virakri Jinangkul. All rights reserved.
//

import Foundation
import UIKit

struct TrainCriteria: Codable {
    let id: Int
    let fromStationJPName: String
    let fromStationName: String
    let toStationJPName: String
    let toStationName: String
    let date: Date
    let trainSchedules: [TrainSchedule]
}

extension TrainCriteria {
    static func fetchData(completion: @escaping (Result<TrainCriteria, Error>) -> Void) {
        DispatchQueue.global(qos: .background).async {
            sleep(1)
            guard let data = NSDataAsset(name: "TrainCriteria")?.data else {
                return completion(.failure(NSError(domain: "SeatMap", code: -900, userInfo: [NSLocalizedFailureReasonErrorKey: "Please check SeatMap.json in assets directory."])))
            }
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                let seatMap = try decoder.decode(TrainCriteria.self, from: data)
                completion(.success(seatMap))
            } catch (let error) {
                completion(.failure(error))
            }
        }
    }
}
