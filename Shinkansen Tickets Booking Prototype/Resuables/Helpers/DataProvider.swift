//
//  DataProvider.swift
//  Shinkansen Tickets Booking Prototype
//
//  Created by Nattawut Singhchai on 19/6/2019 .
//  Copyright © 2019 Virakri Jinangkul. All rights reserved.
//

import SceneKit

extension SeatMap {
    
    /// Async method to get SeatMap data from DataAsset
    /// returns result of `SeatMap`
    /// - Parameter completion: completion block
    static func fetchData(completion: @escaping (Result<SeatMap, Error>) -> Void) {
        DispatchQueue.global(qos: .background).async {
            guard let data = NSDataAsset(name: "SeatMap")?.data else {
                return completion(.failure(NSError(domain: "SeatMap", code: -900, userInfo: [NSLocalizedFailureReasonErrorKey: "Please check SeatMap.json in assets directory."])))
            }
            do {
                // try to decode SeatMap object from json
                let decoder = JSONDecoder()
                let seatMap = try decoder.decode(SeatMap.self, from: data)
                completion(.success(seatMap))
            } catch (let error) {
                completion(.failure(error))
            }
        }
    }
}


extension TrainCriteria {
    
    /// Async method to get TrainCriteria data from DataAsset
    /// returns result of `TrainCriteria`
    /// - Parameter completion: completion block
    static func fetchData(completion: @escaping (Result<TrainCriteria, Error>) -> Void) {
        DispatchQueue.global(qos: .background).async {
            guard let data = NSDataAsset(name: "TrainCriteria")?.data else {
                return completion(.failure(NSError(domain: "SeatMap", code: -900, userInfo: [NSLocalizedFailureReasonErrorKey: "Please check TrainCriteria.json in assets directory."])))
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

