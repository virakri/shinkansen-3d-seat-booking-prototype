//
//  DateLabelSetView.swift
//  Shinkansen Tickets Booking Prototype
//
//  Created by Virakri Jinangkul on 6/1/19.
//  Copyright © 2019 Virakri Jinangkul. All rights reserved.
//

import UIKit
import Kumi

/// A view that displays a pair of headline label and its subheadline, used for station name and time.
class DateLabelSetView: UIStackView {
    
    /// The label used for the main content. In this set, it will be used for a station name.
    var dayOfWeekLabel: Label
    
    /// The label used for the secondary content. In this set, it will be used for showing time.
    var dateLabel: Label
    
    /// Initializes and returns a headline label set view.
    ///
    /// - Parameters:
    ///   - dayOfWeek: The current text that will be displayed by the `titleLabel` of its label set.
    ///   - date: The current text that will be displayed by the `subtitleLabel` of its label set.
    init(dayOfWeek: String,
         date: String) {
        dayOfWeekLabel = Label()
        dateLabel = Label()
        super.init(frame: .zero)
        setupView()
        setupTheme()
        setupValue(dayOfWeek: dayOfWeek,
                   date: date)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        axis = .vertical
        addArrangedSubview(dayOfWeekLabel)
        addArrangedSubview(dateLabel)
        dayOfWeekLabel.textAlignment = .right
        dateLabel.textAlignment = .right
    }
    
    /// Setup text colors, text style, and spacing between labels according to the current theme and current accessibility setup.
    public func setupTheme() {
        dayOfWeekLabel.textColor = currentColorTheme.componentColor.secondaryText
        dateLabel.textColor = currentColorTheme.componentColor.primaryText
        dayOfWeekLabel.textStyle = textStyle.headline()
        dateLabel.textStyle = textStyle.headline()
    }
    
    /// Mutates the texts in two labels
    ///
    /// - Parameters:
    ///   - dayOfWeek: The current text that will be displayed by the `titleLabel` of its label set.
    ///   - date: The current text that will be displayed by the `subtitleLabel` of its label set.
    public func setupValue(dayOfWeek: String,
                           date: String) {
        dayOfWeekLabel.text = dayOfWeek
        dateLabel.text = date
    }
}
