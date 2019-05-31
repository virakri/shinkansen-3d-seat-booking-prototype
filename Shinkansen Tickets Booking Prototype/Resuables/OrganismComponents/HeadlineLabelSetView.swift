//
//  HeadlineLabelSetView.swift
//  Shinkansen Tickets Booking Prototype
//
//  Created by Virakri Jinangkul on 5/30/19.
//  Copyright © 2019 Virakri Jinangkul. All rights reserved.
//

import UIKit
import Kumi

/// A view that displays a pair of headline label and its subheadline, used for station name and time.
class HeadlineLabelSetView: UIStackView {
    
    /// The label used for the main content. In this set, it will be used for a station name.
    var titleLabel: Label
    
    /// The label used for the secondary content. In this set, it will be used for showing time.
    var subtitleLabel: Label
    
    /// Initializes and returns a headline label set view.
    ///
    /// - Parameters:
    ///   - title: The current text that will be displayed by the `titleLabel` of its label set.
    ///   - subtitle: The current text that will be displayed by the `subtitleLabel` of its label set.
    ///   - textAlignment: The technique to use for aligning the text in the set.
    init(title: String,
         subtitle: String? = nil,
         textAlignment: NSTextAlignment = .left) {
        titleLabel = Label()
        subtitleLabel = Label()
        super.init(frame: .zero)
        setupView() 
        setupTheme()
        setupText(title: title,
                  subtitle: subtitle,
                  textAlignment: textAlignment)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        axis = .vertical
        addArrangedSubview(titleLabel)
        addArrangedSubview(subtitleLabel)
    }
    
    /// Setup text colors, text style, and spacing between labels according to the current theme and current accessibility setup.
    public func setupTheme() {
        titleLabel.textColor = currentColorTheme.component.primaryText
        subtitleLabel.textColor = currentColorTheme.component.primaryText
        titleLabel.textStyle = TextStyle.largeTitle
        subtitleLabel.textStyle = TextStyle.subheadline
        spacing = (2 * Constant.multiplier).pixelRounded()
    }
    
    /// Mutates the texts in two labels
    ///
    /// - Parameters:
    ///   - title: The current text that will be displayed by the `titleLabel` of its label set.
    ///   - subtitle: The current text that will be displayed by the `subtitleLabel` of its label set.
    ///   - textAlignment: The technique to use for aligning the text in the set.
    public func setupText(title: String,
                          subtitle: String? = nil,
                          textAlignment: NSTextAlignment = .left) {
        titleLabel.text = title
        subtitleLabel.text = subtitle
        
        titleLabel.textAlignment = textAlignment
        subtitleLabel.textAlignment = textAlignment
    }
}
