//
//  HeaderRouteInformationView.swift
//  Shinkansen Tickets Booking Prototype
//
//  Created by Virakri Jinangkul on 5/31/19.
//  Copyright © 2019 Virakri Jinangkul. All rights reserved.
//

import UIKit

class HeaderRouteInformationView: UIStackView {
    
    var stationPairView: StationPairView
    
    var descriptionSetView: DescriptionSetView
    
    init(fromStation: String, fromTime: String? = nil,
         toStation: String, toTime: String? = nil,
         trainNumber: String? = nil,
         trainName: String? = nil,
         carNumber: String? = nil,
         className: String? = nil,
         seatNumber: String? = nil,
         price: String? = nil) {
        
        stationPairView = .init(fromStation: fromStation, fromTime: fromTime,
                                toStation: toStation, toTime: toTime)
        descriptionSetView = .init(trainNumber: trainNumber ?? " ",
                                   trainName: trainName,
                                   carNumber: carNumber,
                                   className: className,
                                   seatNumber: seatNumber,
                                   price: price)
        
            descriptionSetView.isHidden = trainNumber == nil && trainName == nil &&
                carNumber == nil && className == nil && seatNumber == nil && price == nil
        
        super.init(frame: .zero)
        setupView()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        axis = .vertical
        spacing = min((24 * Constant.multiplier).pixelRounded(), 28)
        addArrangedSubview(stationPairView)
        addArrangedSubview(descriptionSetView)
        print(spacing)
    }
    
    public func setupTheme() {
        stationPairView.setupTheme()
        descriptionSetView.setupTheme()
        spacing = 24 * Constant.multiplier
    }
    
    public func setupValue(fromStation: String, fromTime: String? = nil,
                          toStation: String, toTime: String? = nil,
                          trainNumber: String? = nil,
                          trainName: String? = nil,
                          carNumber: String? = nil,
                          className: String? = nil,
                          seatNumber: String? = nil,
                          price: String? = nil) {
        
        stationPairView.setupValue(fromStation: fromStation, fromTime: fromTime,
                                  toStation: toStation, toTime: toTime)
        descriptionSetView.setupValue(trainNumber: trainNumber ?? " ",
                                     trainName: trainName,
                                     carNumber: carNumber,
                                     className: className,
                                     seatNumber: seatNumber,
                                     price: price)
        
        descriptionSetView.isHidden = trainNumber == nil && trainName == nil &&
            carNumber == nil && className == nil && seatNumber == nil && price == nil
    }
}
