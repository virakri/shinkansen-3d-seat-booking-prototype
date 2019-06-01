//
//  TrainScheduleTableViewCell.swift
//  Shinkansen Tickets Booking Prototype
//
//  Created by Virakri Jinangkul on 5/31/19.
//  Copyright © 2019 Virakri Jinangkul. All rights reserved.
//

import UIKit

class TrainScheduleTableViewCell: UITableViewCell {
    var cardView: CardControl
    var timeLabelSetView: LabelSetView
    var trainLabelSetView: LabelSetView
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
        preservesSuperviewLayoutMargins = true
        contentView.preservesSuperviewLayoutMargins = true
        
        selectionStyle = .none
        
        contentView.isUserInteractionEnabled = false
        
//        self.constraintAllEdges(to: contentView)
//        addSubview(contentView, withConstaintEquals: .edges, insetsConstant: .zero)
//        addSubview(contentView)
//        contentView.translatesAutoresizingMaskIntoConstraints = false
//        constraintAllEdges(to: contentView)
//        topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
//        bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
//        leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
//        trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        
        contentView.addSubview(cardView,
                               withConstaintEquals: [.leadingMargin, .trailingMargin, .top, .bottom],
                               insetsConstant: .init(top: 4, leading: 0, bottom: 12, trailing: 0))
        
        cardView.directionalLayoutMargins = Constant.cardLayoutMarginInset
        
        let headerTextDetailStackView = UIStackView([timeLabelSetView, trainLabelSetView],
                                                    axis: .horizontal,
                                                    distribution: .equalSpacing,
                                                    alignment: .firstBaseline)
        
        let verticalStackView = UIStackView([headerTextDetailStackView],
                                            axis: .vertical,
                                            distribution: .fill,
                                            alignment: .fill,
                                            spacing: 0)
        
        cardView.addSubview(verticalStackView,
                            withConstaintEquals: .marginEdges,
                            insetsConstant: .zero)
    }
    
    public func setupTheme() {
//        priceLabel.textStyle =
    }
    
    public func setupValue(time: String,
                           amountOfTime: String? = nil,
                           trainNumber: String? = nil,
                           trainName: String? = nil,
                           price: String? = nil,
                           trainImage: UIImage? = nil) {
        timeLabelSetView.setupValue(title: time, subtitle: amountOfTime)
        trainLabelSetView.setupValue(title: trainNumber, subtitle: trainName)
        priceLabel.text = price
    }
}
