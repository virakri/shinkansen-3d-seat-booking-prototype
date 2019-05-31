//
//  StationPairView.swift
//  Shinkansen Tickets Booking Prototype
//
//  Created by Virakri Jinangkul on 5/30/19.
//  Copyright © 2019 Virakri Jinangkul. All rights reserved.
//

import UIKit
import Kumi

class StationPairView: UIStackView {
    
    var fromStationHeadlineView: HeadlineLabelSetView
    
    var toStationHeadlineView: HeadlineLabelSetView
    
    var toLabel: Label
    
    init(fromStation: String, fromTime: String? = nil,
         toStation: String, toTime: String? = nil) {
        fromStationHeadlineView = HeadlineLabelSetView(title: fromStation, subtitle: fromTime, textAlignment: .left)
        toStationHeadlineView = HeadlineLabelSetView(title: toStation, subtitle: toTime, textAlignment: .right)
        toLabel = Label()
        super.init(frame: .zero)
        setupView()
        setupTheme()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        alignment = .firstBaseline
        distribution = .equalSpacing
        addArrangedSubview(fromStationHeadlineView)
        addArrangedSubview(toLabel)
        addArrangedSubview(toStationHeadlineView)
        
        toLabel.text = "to"
        toLabel.textAlignment = .center
    }
    
    public func setupTheme() {
        fromStationHeadlineView.setupTheme()
        toStationHeadlineView.setupTheme()
        toLabel.textColor = currentColorTheme.component.secondaryText
        toLabel.textStyle = TextStyle.subheadline
    }
    
    public func setupText(fromStation: String, fromTime: String? = nil,
                          toStation: String, toTime: String? = nil) {
        fromStationHeadlineView.setupText(title: fromStation, subtitle: fromTime)
        toStationHeadlineView.setupText(title: toStation, subtitle: toTime)
    }
}
