//
//  URL.swift
//  Shinkansen Tickets Booking Prototype
//
//  Created by Nattawut Singhchai on 14/6/2019 .
//  Copyright © 2019 Virakri Jinangkul. All rights reserved.
//

import Foundation

extension URL {
    static func resource(name resourceName: String) -> URL? {
        return Bundle.main.url(forResource: "SeatMap.scnassets/\(resourceName)", withExtension: nil)
    }
}
