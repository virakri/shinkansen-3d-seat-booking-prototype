//
//  LabelSetView.swift
//  Shinkansen Tickets Booking Prototype
//
//  Created by Virakri Jinangkul on 5/30/19.
//  Copyright © 2019 Virakri Jinangkul. All rights reserved.
//

import UIKit
import Kumi

/// A view that displays a pair of headline label and its subheadline, used for station name and time.
class LabelSetView: UIStackView {
    
    /// Specifies the style of this label set view.
    ///
    /// - regular: A normal style of label set used for headline of card view cells.
    /// - small: A supplementary style of label set used for adding more context of card view cells.
    enum _Type {
        case regular
        case small
        
        /// Return `TextStyle` for `titleLabel` according to `_Type` selected.
        ///
        /// - Returns: `TextStyle` for `Label`
        func textStyleForTitleLabel() -> TextStyle {
            switch self {
            case .regular:
                return TextStyle.headline
            case .small:
                return TextStyle.caption1
            }
        }
    }
    
    fileprivate var type: _Type
    
    /// The label used for the main content. In this set, it will be used for a station name.
    var titleLabel: Label
    
    /// The label used for the secondary content. In this set, it will be used for showing time.
    var subtitleLabel: Label
    
    init(type: _Type, title: String, subtitle: String? = nil) {
        self.type = type
        titleLabel = Label()
        subtitleLabel = Label()
        super.init(frame: .zero)
        setupTheme()
        setupText(title: title, subtitle: subtitle)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addArrangedSubview(titleLabel)
        addArrangedSubview(subtitleLabel)
    }
    
    /// Setup text colors, text style, and spacing between labels according to the current theme and current accessibility setup.
    public func setupTheme() {
        titleLabel.textColor = currentColorTheme.component.primaryText
        subtitleLabel.textColor = currentColorTheme.component.secondaryText
        titleLabel.textStyle = type.textStyleForTitleLabel()
        subtitleLabel.textStyle = TextStyle.caption2
    }
    
    /// Mutates the texts in two labels
    ///
    /// - Parameters:
    ///   - title: The current text that will be displayed by the `titleLabel` of its label set.
    ///   - subtitle: The current text that will be displayed by the `subtitleLabel` of its label set.
    public func setupText(title: String, subtitle: String? = nil) {
        titleLabel.text = title
        subtitleLabel.text = subtitle
    }
}
