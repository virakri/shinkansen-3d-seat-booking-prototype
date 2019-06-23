//
//  DescriptionSetView.swift
//  Shinkansen 3D Seat Booking Prototype
//
//  Created by Virakri Jinangkul on 5/31/19.
//  Copyright © 2019 Virakri Jinangkul. All rights reserved.
//

import UIKit
import Kumi

class DescriptionSetView: UIStackView {
    
    var trainNumberSetView: SubheadlineLabelSetView
    
    var carNumberSetView: SubheadlineLabelSetView
    
    var seatNumberSetView: SubheadlineLabelSetView
    
    var priceSetView: SubheadlineLabelSetView
    
    init(trainNumber: String = " ",
         trainName: String? = nil,
         carNumber: String? = nil,
         className: String? = nil,
         seatNumber: String? = nil,
         price: String? = nil) {
        trainNumberSetView = SubheadlineLabelSetView(title: trainNumber, subtitle: trainName, textAlignment: .left)
        carNumberSetView = SubheadlineLabelSetView(title: carNumber ?? "", subtitle: className, textAlignment: .center)
        seatNumberSetView = SubheadlineLabelSetView(title: seatNumber ?? "", textAlignment: .center)
        priceSetView = SubheadlineLabelSetView(title: price ?? "", textAlignment: .right)
        super.init(frame: .zero)
        setupView()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        distribution = .equalSpacing
        addArrangedSubview(trainNumberSetView)
        addArrangedSubview(carNumberSetView)
        addArrangedSubview(seatNumberSetView)
        addArrangedSubview(priceSetView)
    }
    
    public func setupTheme() {
        trainNumberSetView.setupTheme()
        carNumberSetView.setupTheme()
        seatNumberSetView.setupTheme()
        priceSetView.setupTheme()
    }
    
    public func setupValue(trainNumber: String = " ",
                          trainName: String? = nil,
                          carNumber: String? = nil,
                          className: String? = nil,
                          seatNumber: String? = nil,
                          price: String? = nil) {
        trainNumberSetView.setupValue(title: trainNumber, subtitle: trainName)
        carNumberSetView.setupValue(title: carNumber ?? "", subtitle: className)
        carNumberSetView.isHidden = carNumber == nil && className == nil
        seatNumberSetView.setupValue(title: seatNumber ?? "")
        seatNumberSetView.isHidden = seatNumber == nil
        priceSetView.setupValue(title: price ?? "")
        priceSetView.isHidden = price == nil
    }
}
