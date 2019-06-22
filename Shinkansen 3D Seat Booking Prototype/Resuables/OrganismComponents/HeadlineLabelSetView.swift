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
    
    /// The technique to use for aligning the text in the set.
    var textAlignment: NSTextAlignment = .natural {
        didSet {
            setTextAlignment()
        }
    }
    
    /// Initializes and returns a headline label set view.
    ///
    /// - Parameters:
    ///   - title: The current text that will be displayed by the `titleLabel` of its label set.
    ///   - subtitle: The current text that will be displayed by the `subtitleLabel` of its label set.
    ///   - textAlignment: The technique to use for aligning the text in the set.
    init(title: String = " ",
         subtitle: String? = nil,
         textAlignment: NSTextAlignment = .natural) {
        titleLabel = Label()
        subtitleLabel = Label()
        super.init(frame: .zero)
        setupView() 
        setupTheme()
        setupValue(title: title,
                  subtitle: subtitle)
        self.textAlignment = textAlignment
        setTextAlignment()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        axis = .vertical
        addArrangedSubview(titleLabel)
        addArrangedSubview(subtitleLabel)
    }
    
    private func setTextAlignment() {
        titleLabel.textAlignment = textAlignment
        subtitleLabel.textAlignment = textAlignment
    }
    
    /// Setup text colors, text style, and spacing between labels according to the current theme and current accessibility setup.
    public func setupTheme() {
        titleLabel.textColor = currentColorTheme.componentColor.primaryText
        subtitleLabel.textColor = currentColorTheme.componentColor.primaryText
        titleLabel.textStyle = textStyle.largeTitle()
        subtitleLabel.textStyle = textStyle.subheadline()
        spacing = CGFloat(2).systemSizeMuliplier()
        setTextAlignment()
    }
    
    /// Mutates the texts in two labels
    ///
    /// - Parameters:
    ///   - title: The current text that will be displayed by the `titleLabel` of its label set.
    ///   - subtitle: The current text that will be displayed by the `subtitleLabel` of its label set.
    ///   - textAlignment: The technique to use for aligning the text in the set.
    public func setupValue(title: String,
                          subtitle: String? = nil) {
        titleLabel.text = title
        subtitleLabel.text = subtitle
    }
}
