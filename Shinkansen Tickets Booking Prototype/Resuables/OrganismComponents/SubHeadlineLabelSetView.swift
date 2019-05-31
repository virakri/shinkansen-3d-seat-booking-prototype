//
//  SubHeadlineLabelSet.swift
//  Shinkansen Tickets Booking Prototype
//
//  Created by Virakri Jinangkul on 5/30/19.
//  Copyright © 2019 Virakri Jinangkul. All rights reserved.
//

import UIKit
import Kumi

/// A view that displays a pair of headline label and its subheadline, used for properties in booking views.
class SubheadlineLabelSetView: UIStackView {
    
    /// The label used for the main content.
    var titleLabel: Label
    
    /// The label used for the secondary content.
    var subtitleLabel: Label
    
    /// The technique to use for aligning the text in the set.
    var textAlignment: NSTextAlignment = .natural {
        didSet {
            setTextAlignment()
        }
    }
    
    fileprivate var subtitlePlaceholderLabel: Label
    
    fileprivate var subtitleHorizontalConstraint: NSLayoutConstraint?
    
    /// Initializes and returns a subheadline label set view.
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
        subtitlePlaceholderLabel = Label()
        subtitlePlaceholderLabel.text = " "
        super.init(frame: .zero)
        setupView() 
        setupTheme()
        setupText(title: title,
                  subtitle: subtitle)
        self.textAlignment = textAlignment
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        axis = .vertical
        addArrangedSubview(titleLabel)
        addArrangedSubview(subtitlePlaceholderLabel)
        addSubview(subtitleLabel)
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.centerYAnchor.constraint(equalTo: subtitlePlaceholderLabel.centerYAnchor).isActive = true
    }
    
    private func setTextAlignment() {
        titleLabel.textAlignment = textAlignment
        subtitleLabel.textAlignment = textAlignment
        
        if let constraint = subtitleHorizontalConstraint {
            removeConstraint(constraint)
        }
        
        switch textAlignment {
        case .left:
            subtitleHorizontalConstraint = subtitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor)
        case .center:
            subtitleHorizontalConstraint = subtitleLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        case .right:
            subtitleHorizontalConstraint = subtitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        default:
            subtitleHorizontalConstraint = subtitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor)
        }
        subtitleHorizontalConstraint?.isActive = true
    }
    
    /// Setup text colors, text style, and spacing between labels according to the current theme and current accessibility setup.
    public func setupTheme() {
        titleLabel.textColor = currentColorTheme.component.primaryText
        subtitleLabel.textColor = currentColorTheme.component.secondaryText
        titleLabel.textStyle = TextStyle.headline
        subtitleLabel.textStyle = TextStyle.caption1
        subtitlePlaceholderLabel.textStyle = subtitleLabel.textStyle
        spacing = (2 * Constant.multiplier).pixelRounded()
        setTextAlignment()
    }
    
    /// Mutates the texts in two labels
    ///
    /// - Parameters:
    ///   - title: The current text that will be displayed by the `titleLabel` of its label set.
    ///   - subtitle: The current text that will be displayed by the `subtitleLabel` of its label set.
    public func setupText(title: String,
                          subtitle: String? = nil) {
        titleLabel.text = title
        subtitleLabel.text = subtitle
    }
}
