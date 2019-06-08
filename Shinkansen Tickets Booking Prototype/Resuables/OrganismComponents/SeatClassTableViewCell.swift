//
//  SeatClassTableViewCell.swift
//  Shinkansen Tickets Booking Prototype
//
//  Created by Virakri Jinangkul on 6/1/19.
//  Copyright © 2019 Virakri Jinangkul. All rights reserved.
//

import UIKit
import Kumi

class SeatClassTableViewCell: UITableViewCell {
    var cardView: CardControl
    var seatClassIconImageView: SeatClassIconImageView
    var seatClassNameSetView: LabelSetView
    var descriptionLabel: Label
    var seatImageView: UIImageView
    
    public var basedHeight: CGFloat = 108 {
        didSet {
            setupTheme()
        }
    }
    
    private var seatImageViewHeightConstraint: NSLayoutConstraint?
    
    convenience init() {
        self.init(style: .default, reuseIdentifier: nil)
        
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        cardView = CardControl(type: .regular)
        seatClassNameSetView = LabelSetView(type: .regular, textAlignment: .left)
        seatClassIconImageView = SeatClassIconImageView(seatClass: .granClass,
                                                        iconSize: .regular)
        descriptionLabel = Label()
        seatImageView = UIImageView()
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
        
        let seatClassIconContainerView = UIView(containingView: seatClassIconImageView,
                                            withConstaintEquals: [.leading, .trailing],
                                            insetsConstant: .init(vertical: 0, horizontal: 2))
        
        let textContentStackView = UIStackView([seatClassNameSetView, descriptionLabel],
                                               axis: .vertical,
                                               distribution: .fill,
                                               alignment: .fill,
                                               spacing: 10)
        
        let mainContentStackView = UIStackView([seatClassIconContainerView, textContentStackView],
                                               distribution: .fill,
                                               alignment: .fill,
                                               spacing: 10)
        
        seatClassIconImageView.centerYAnchor.constraint(equalTo: seatClassNameSetView.centerYAnchor).isActive = true
        
        cardView.contentView.addSubview(mainContentStackView,
                                        withConstaintEquals: [.topMargin, .leadingMargin])
        
//        cardView.contentView.layoutMarginsGuide.bottomAnchor.constraint(greaterThanOrEqualTo: mainContentStackView.bottomAnchor).isActive = true
        
        cardView.contentView.addSubview(seatImageView, withConstaintEquals: [.top, .bottom, .trailing])
        
        
        seatImageView.leadingAnchor.constraint(equalTo: mainContentStackView.trailingAnchor,
                                               constant: 16).isActive = true
        seatImageViewHeightConstraint = seatImageView.heightAnchor
            .constraint(equalToConstant: CGFloat(basedHeight)
                .systemSizeMuliplier())
        seatImageViewHeightConstraint?.isActive = true
        seatImageView.widthAnchor.constraint(equalTo: seatImageView.heightAnchor, multiplier: 4 / 5).isActive = true
        
        seatImageView.setContentCompressionResistancePriority(.init(rawValue: 249), for: .vertical)
        seatImageView.setContentCompressionResistancePriority(.init(rawValue: 249), for: .horizontal)
        
        seatImageView.image = nil
        seatImageView.backgroundColor = currentColorTheme.componentColor.callToActionDisabled
        
        contentView.addSubview(cardView,
                               withConstaintEquals: [.leadingMargin, .trailingMargin, .top, .bottom],
                               insetsConstant: .init(top: 4, leading: 0, bottom: 12, trailing: 0))
        
        // MARK: Set views' properties
        descriptionLabel.numberOfLines = 0
    }
    
    public func setupTheme() {
        seatClassNameSetView.setupTheme()
        seatClassIconImageView.setupTheme()
        descriptionLabel.textStyle = textStyle.caption1()
        descriptionLabel.textColor = currentColorTheme.componentColor.secondaryText
        descriptionLabel.lineBreakMode = .byTruncatingTail
        seatImageViewHeightConstraint?.constant = CGFloat(basedHeight).systemSizeMuliplier()
    }
    
    public func setupValue(seatClassType: SeatClassType,
                           seatClassName: String,
                           price: String? = nil,
                           description: String? = nil,
                           seatImage: UIImage? = nil) {
        seatClassIconImageView.setSeatClass(to: seatClassType)
        seatClassNameSetView.setupValue(title: seatClassName, subtitle: price)
        descriptionLabel.text = description
        setupTheme()
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        cardView.isHighlighted = highlighted
    }
}
