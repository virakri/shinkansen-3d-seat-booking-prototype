//
//  TrainScheduleTableViewCell.swift
//  Shinkansen Tickets Booking Prototype
//
//  Created by Virakri Jinangkul on 5/31/19.
//  Copyright © 2019 Virakri Jinangkul. All rights reserved.
//

import UIKit
import Kumi

class TrainScheduleTableViewCell: UITableViewCell {
    var cardView: CardControl
    var timeLabelSetView: LabelSetView
    var trainLabelSetView: LabelSetView
    var granClassIconImageView: SeatClassIconImageView
    var greenIconImageView: SeatClassIconImageView
    var ordinaryIconImageView: SeatClassIconImageView
    var priceLabel: Label
    var classIconStackView: UIStackView
    var trainImageView: UIImageView
    
    convenience init() {
        self.init(style: .default, reuseIdentifier: nil)
        
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        cardView = CardControl(type: .regular)
        timeLabelSetView = LabelSetView(type: .regular, textAlignment: .left)
        trainLabelSetView = LabelSetView(type: .small, textAlignment: .right)
        granClassIconImageView = SeatClassIconImageView(seatClass: .granClass,
                                                        iconSize: .small)
        greenIconImageView = SeatClassIconImageView(seatClass: .green,
                                                    iconSize: .small)
        ordinaryIconImageView = SeatClassIconImageView(seatClass: .ordinary,
                                                       iconSize: .small)
        priceLabel = Label()
        classIconStackView = UIStackView()
        trainImageView = UIImageView()
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        setupTheme()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        selectionStyle = .none
        preservesSuperviewLayoutMargins = true
        contentView.preservesSuperviewLayoutMargins = true
        contentView.isUserInteractionEnabled = false
        
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        
        contentView.addSubview(cardView,
                               withConstaintEquals: [.leadingMargin, .trailingMargin, .top, .bottom],
                               insetsConstant: .init(top: 4, leading: 0, bottom: 12, trailing: 0))
        
        let seatClassStackView = UIStackView([granClassIconImageView,
                                              greenIconImageView,
                                              ordinaryIconImageView], distribution: .fill, alignment: .fill, spacing: 8)
        
        let seatClassAndPriceStackView = UIStackView([seatClassStackView, priceLabel],
                                                     axis: .vertical,
                                                     distribution: .fill, alignment: .leading, spacing: 4)
        
        let headerTextDetailStackView = UIStackView([timeLabelSetView, trainLabelSetView],
                                                    axis: .horizontal,
                                                    distribution: .equalSpacing,
                                                    alignment: .top)
        
        let verticalStackView = UIStackView([headerTextDetailStackView, seatClassAndPriceStackView],
                                            axis: .vertical,
                                            distribution: .fill,
                                            alignment: .fill,
                                            spacing: 24)
        
        cardView.contentView.addSubview(verticalStackView,
                            withConstaintEquals: .marginEdges,
                            insetsConstant: .zero)
        
        cardView.contentView.addSubview(trainImageView, withConstaintEquals: [.bottomMargin])
        trainImageView.topAnchor.constraint(equalTo: headerTextDetailStackView.bottomAnchor, constant: 8).isActive = true
        cardView.centerXAnchor.constraint(equalTo: trainImageView.leadingAnchor, constant: 32).isActive = true
        trainImageView.widthAnchor.constraint(equalTo: trainImageView.heightAnchor, multiplier: 6).isActive = true
        trainImageView.setContentCompressionResistancePriority(.init(rawValue: 249), for: .vertical)
        trainImageView.setContentCompressionResistancePriority(.init(rawValue: 249), for: .horizontal)
       
        trainImageView.image = #imageLiteral(resourceName: "image-example-train")
    }
    
    public func setupTheme() {
        timeLabelSetView.setupTheme()
        trainLabelSetView.setupTheme()
        granClassIconImageView.setupTheme()
        greenIconImageView.setupTheme()
        ordinaryIconImageView.setupTheme()
        priceLabel.textStyle = textStyle.caption2()
        priceLabel.textColor = currentColorTheme.componentColor.secondaryText
    }
    
    public func setupValue(time: String,
                           amountOfTime: String? = nil,
                           trainNumber: String? = nil,
                           trainName: String? = nil,
                           isGranClassAvailable: Bool = true,
                           isGreenAvailable: Bool = true,
                           isOrdinaryAvailable: Bool = true,
                           price: String? = nil,
                           trainImage: UIImage? = nil) {
        timeLabelSetView.setupValue(title: time, subtitle: amountOfTime)
        trainLabelSetView.setupValue(title: trainNumber, subtitle: trainName)
        granClassIconImageView.isAvailable = isGranClassAvailable
        greenIconImageView.isAvailable = isGreenAvailable
        ordinaryIconImageView.isAvailable = isOrdinaryAvailable
        priceLabel.text = price
    }
    
    public func preparePropertiesForAnimation() {
        contentView.alpha = 0
        trainImageView.transform.tx = trainImageView.bounds.width
    }
    
    public func setPropertiesToIdentity() {
        contentView.alpha = 1
        trainImageView.transform.tx = 0
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        cardView.isHighlighted = highlighted
    }
}
