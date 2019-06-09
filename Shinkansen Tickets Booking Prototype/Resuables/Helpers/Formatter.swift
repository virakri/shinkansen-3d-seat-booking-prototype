//
//  Formatter.swift
//  Shinkansen Tickets Booking Prototype
//
//  Created by Nattawut Singhchai on 6/8/19.
//  Copyright © 2019 Virakri Jinangkul. All rights reserved.
//

import Foundation

class TimeFormatter: DateFormatter {
    override init() {
        super.init()
        timeStyle = .short
        timeZone = Date.JPCalendar.timeZone
        calendar = Date.JPCalendar
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class YenFormatter: NumberFormatter {
    override init() {
        super.init()
        usesGroupingSeparator = true
        numberStyle = .currency
        locale = Locale(identifier: "ja_JP")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class FullDateFormatter: DateFormatter {
    override init() {
        super.init()
        dateStyle = .long
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
