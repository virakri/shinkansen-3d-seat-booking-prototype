//
//  Numuric.swift
//  Shinkansen Tickets Booking Prototype
//
//  Created by Nattawut Singhchai on 9/6/2562 BE.
//  Copyright © 2562 Virakri Jinangkul. All rights reserved.
//

import Foundation

extension Numeric {
    var yen: String {
        return YenFormatter().string(for: self)!
    }
}
