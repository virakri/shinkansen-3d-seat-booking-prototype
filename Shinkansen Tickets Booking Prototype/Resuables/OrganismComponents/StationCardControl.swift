//
//  StationCardControl.swift
//  Shinkansen Tickets Booking Prototype
//
//  Created by Virakri Jinangkul on 6/2/19.
//  Copyright © 2019 Virakri Jinangkul. All rights reserved.
//

import UIKit
import Kumi

class StationCardControl: CardControl {
    
    var basedHeight: CGFloat = DesignSystem.isNarrowScreen ? 64 : 72 {
        didSet {
            heightConstraint.constant = basedHeight.systemSizeMuliplier()
        }
    }
    
    var stationNameJP: String?
    
    var stationName: String?
    
    private var heightConstraint: NSLayoutConstraint
    
    private var contentStackView: UIStackView
    
    private var stationNameJPLabel: Label
    
    private var stationNameLabel: Label
    
    init(stationNameJP: String? = nil,
         stationName: String? = nil) {
        heightConstraint = NSLayoutConstraint()
        contentStackView = UIStackView()
        stationNameJPLabel = Label()
        stationNameLabel = Label()
        super.init(type: .regular)
        setupView()
        setupValue(stationNameJP: stationNameJP, stationName: stationName)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        
        translatesAutoresizingMaskIntoConstraints = false
        heightConstraint = heightAnchor.constraint(equalToConstant: basedHeight)
        
        heightConstraint.isActive = true
        contentStackView.spacing = 0
        
        stationNameJPLabel.textAlignment = .center
        stationNameLabel.textAlignment = .center
        
        contentStackView.addArrangedSubview(stationNameJPLabel)
        contentStackView.addArrangedSubview(stationNameLabel)
        
        contentStackView.axis = .vertical
        
        contentView.addSubview(contentStackView, withConstaintEquals: .center)
        contentView.addConstraints(toView: contentStackView, withConstaintGreaterThanOrEquals: .marginEdges)
        
        contentView.directionalLayoutMargins = DesignSystem.layoutMargins.itemCardControl()
    }
    
    public func setupValue(stationNameJP: String? = nil,
                    stationName: String? = nil) {
        stationNameJPLabel.text = stationNameJP
        stationNameLabel.text = stationName
    }
    
    public override func setupTheme() {
        super.setupTheme()
        
        heightConstraint.constant = basedHeight.systemSizeMuliplier()
        
        stationNameJPLabel.textStyle = textStyle.title1()
        stationNameLabel.textStyle = textStyle.caption1Alt()
        
        stationNameJPLabel.textColor = currentColorTheme.componentColor.callToAction
        stationNameLabel.textColor = currentColorTheme.componentColor.callToAction
    }
}
