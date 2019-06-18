//
//  SegmentedItemControl.swift
//  Shinkansen Tickets Booking Prototype
//
//  Created by Virakri Jinangkul on 6/10/19.
//  Copyright © 2019 Virakri Jinangkul. All rights reserved.
//

import UIKit
import Kumi

class SegmentedItemControl: UIControl {
    
    private var heightConstraint: NSLayoutConstraint!
    
    static let feedbackGenerator = UISelectionFeedbackGenerator()
    
    var title: String
    
    var subtitle: String
    
    var titleLabel: Label
    
    var unselectedTitleLabel: Label
    
    var subtitleLabel: Label
    
    var basedHeight: CGFloat = DesignSystem.isNarrowScreen ? 56 : 56 {
        didSet {
            setupTheme()
        }
    }
    
    public var contentView: UIView
    
    override var isEnabled: Bool {
        didSet {
            currentState = isEnabled ? .normal : .disabled
            unselectedTitleLabel.text = isEnabled ? title : "~~\(title)~~"
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            if !isSelected {
                currentState = isHighlighted ? .highlighted : .normal
                if oldValue != isHighlighted && isHighlighted {
                    SegmentedItemControl
                        .feedbackGenerator
                        .selectionChanged()
                }
            }
        }
    }
    
    override var isSelected: Bool {
        didSet {
            currentState = isSelected ? .selected : .normal
        }
    }
    
    var animated: Bool = true
    
    var currentState: State {
        didSet {
            updateAppearance(animated: animated)
        }
    }
    
    init(title: String, subtitle: String) {
        contentView = UIView()
        currentState = .normal
        self.title = title
        self.subtitle = subtitle
        titleLabel = Label()
        unselectedTitleLabel = Label()
        subtitleLabel = Label()
        super.init(frame: .zero)
        
        // Setup View
        setupView()
        setupTheme()
        
        // Setup Text in Labels
        titleLabel.text = self.title
        unselectedTitleLabel.text = self.title
        subtitleLabel.text = self.subtitle
        
        updateAppearance(animated: false)
    }
    
    override init(frame: CGRect) {
        contentView = UIView()
        currentState = .normal
        title = ""
        subtitle = ""
        titleLabel = Label()
        unselectedTitleLabel = Label()
        subtitleLabel = Label()
        super.init(frame: .zero)
        
        // Setup View
        setupView()
        setupTheme()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        // Manually defining shadowPath helps the system to perform better by not having them redefine the shape of the layer ever single time when the view needs to be rendered
        layer.shadowPath = CGPath(roundedRect: rect,
                                  cornerWidth: layer.cornerRadius,
                                  cornerHeight: layer.cornerRadius,
                                  transform: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        contentView.clipsToBounds = true
        contentView.isUserInteractionEnabled = false
        contentView
            .directionalLayoutMargins = DesignSystem
                .layoutMargins
                .segmentedItemControl()
        addSubview(contentView, withConstaintEquals: .edges)
        contentView
            .layer
            .setLayer(
                layerStyle(by: currentState)
                    .withShadowStyle(
                        shadowStyle.noShadow()
            )
        )
        
        layer
            .setLayer(
                layerStyle(by: currentState)
        )
        
        // Properties
        isUserInteractionEnabled = false
        titleLabel.adjustsFontSizeToFitWidth = true
        unselectedTitleLabel.adjustsFontSizeToFitWidth = true
        subtitleLabel.adjustsFontSizeToFitWidth = true
        
        // Initialize Height Constraint
        heightConstraint = heightAnchor.constraint(equalToConstant: basedHeight.systemSizeMuliplier())
        heightConstraint.isActive = true
        
        contentView.addSubview(unselectedTitleLabel, withConstaintEquals: [.center])
        contentView.addConstraints(toView: unselectedTitleLabel, withConstaintGreaterThanOrEquals: [.marginEdges])
        
        let contentStackView = UIStackView([titleLabel, subtitleLabel],
                                           axis: .vertical,
                                           distribution: .fill,
                                           alignment: .center,
                                           spacing: 2)
        
        contentView.addSubview(contentStackView, withConstaintEquals: [.center])
        contentView.addConstraints(toView: contentStackView, withConstaintGreaterThanOrEquals: [.marginEdges])
    }
    
    private func layerStyle(by state: State) -> LayerStyle {
        switch state {
        case .normal:
            return DesignSystem.layerStyle.segmentedItem.normal()
        case .selected:
            return DesignSystem.layerStyle.segmentedItem.selected()
        default:
            return DesignSystem.layerStyle.segmentedItem.normal()
        }
    }
    
    private func updateAppearance(animated: Bool = true) {
        let contentViewOpacity = currentState == .highlighted ? DesignSystem.opacity.highlighted : 1
        contentView.layer.setAnimatedLayer(layerStyle(by: currentState)
            .withShadowStyle(shadowStyle.noShadow())
            .withOpacity(contentViewOpacity),
                                           using: CABasicAnimationStyle.layerAnimationStyle)
        let transform = currentState == .highlighted ? DesignSystem.CATransform.highlighted : DesignSystem.CATransform.normal
        layer.setAnimatedLayer(layerStyle(by: currentState)
            .withTransform(transform),
                               using: CABasicAnimationStyle.layerAnimationStyle)
        
        setLabelsToSelected(currentState == .selected, animated: animated)
        
    }
    
    public func setupTheme() {
        
        titleLabel.textStyle = textStyle.headline()
        unselectedTitleLabel.textStyle = textStyle.headline().strikethrough()
        subtitleLabel.textStyle = textStyle.caption2()
        
        titleLabel.textColor = currentColorTheme.componentColor.callToAction
        unselectedTitleLabel.textColor = currentColorTheme.componentColor.secondaryText
        subtitleLabel.textColor = currentColorTheme.componentColor.secondaryText
        
        heightConstraint?.constant = CGFloat(basedHeight).systemSizeMuliplier()
        
        updateAppearance(animated: false)
    }
    
    private func setLabelsToSelected(_ isSelected: Bool, animated: Bool = true) {
        guard let contentSuperView = titleLabel.superview else { return }
        
        titleLabel.transform.ty = isSelected ? 0 : titleLabel.transform.ty
        unselectedTitleLabel.transform.ty = isSelected ? unselectedTitleLabel.transform.ty : 0
        
        let titleLabelInContentViewFrame = contentSuperView
            .convert(titleLabel.frame,
                     to: contentView)
        let labelVerticalDisplacement = titleLabelInContentViewFrame.midY - unselectedTitleLabel.frame.midY
        
        let scaleFactor: CGFloat = isSelected ? 1 : 0.8
        let scaleTransform = CGAffineTransform(scaleX: scaleFactor, y: scaleFactor)
        
        let action = {
            self.titleLabel.transform = scaleTransform
            self.subtitleLabel.transform = scaleTransform
            self.unselectedTitleLabel.transform = scaleTransform
            
            self.titleLabel.transform.ty = isSelected ? 0 : -labelVerticalDisplacement
            self.subtitleLabel.transform.ty = isSelected ? 0 : labelVerticalDisplacement / 3
            self.unselectedTitleLabel.transform.ty = isSelected ? labelVerticalDisplacement : 0
            
            self.titleLabel.alpha = isSelected ? 1 : 0
            self.subtitleLabel.alpha = isSelected ? 1 : 0
            
            self.unselectedTitleLabel.alpha = isSelected ? 0 : 1
        }
        
        if animated {
            UIView.animate(withStyle: .normalAnimationStyle, animations: action)
        } else {
            action()
        }
        
    }
}
