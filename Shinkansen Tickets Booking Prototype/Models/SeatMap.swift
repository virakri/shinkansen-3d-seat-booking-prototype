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
    let transformedModelEntities: [TransformedModelEntity]
}

extension SeatMap {
    static func fetchData(completion: @escaping (Result<SeatMap, Error>) -> Void) {
        DispatchQueue.global(qos: .background).async {
            guard let data = NSDataAsset(name: "SeatMap")?.data else {
                return completion(.failure(NSError(domain: "SeatMap", code: -900, userInfo: [NSLocalizedFailureReasonErrorKey: "Please check SeatMap.json in assets directory."])))
            }
            do {
                let decoder = JSONDecoder()
                let seatMap = try decoder.decode(SeatMap.self, from: data)
                completion(.success(seatMap))
            } catch (let error) {
                completion(.failure(error))
            }
        }
    }
}
