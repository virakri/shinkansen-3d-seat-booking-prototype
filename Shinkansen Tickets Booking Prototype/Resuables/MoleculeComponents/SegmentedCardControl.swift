//
//  SegmentedCardControl.swift
//  Shinkansen Tickets Booking Prototype
//
//  Created by Virakri Jinangkul on 6/2/19.
//  Copyright © 2019 Virakri Jinangkul. All rights reserved.
//

import UIKit

class SegmentedCardControl: UIControl {
    class ItemCardControl: UIControl {
        
        private var currentState: State {
            didSet {
                if oldValue != currentState {
                    updateAppearance()
                }
            }
        }
        
        private var cardControl: CardControl
        
        private var heightConstraint: NSLayoutConstraint!
        
        var titleLabel: Label
        
        var unselectedTitleLabel: Label
        
        var subtitleLabel: Label
        
        var basedHeight: CGFloat = DesignSystem.isNarrowScreen ? 56 : 56 {
            didSet {
                setupTheme()
            }
        }
        
        override var isSelected: Bool {
            didSet {
                currentState = isSelected ? .selected : .normal
            }
        }
        
//        override var isEnabled: Bool {
//            didSet {
//                currentState = isEnabled ? .normal : .disabled
//            }
//        }
        
        static let hipticGenerator = UISelectionFeedbackGenerator()
        
        override var isHighlighted: Bool {
            didSet {
                if !isSelected {
                    currentState = isHighlighted ? .highlighted : .normal
                    if oldValue != isHighlighted && isHighlighted {
                        SegmentedCardControl.ItemCardControl.hipticGenerator.selectionChanged()
                    }
                }
            }
        }
        
        init(title: String, subtitle: String) {
            currentState = .normal
            cardControl = CardControl(type: .regular)
            titleLabel = Label()
            unselectedTitleLabel = Label()
            subtitleLabel = Label()
            super.init(frame: .zero)
            
            // Setup View
            setupView()
            setupTheme()
            
            // Setup Text in Labels
            titleLabel.text = title
            unselectedTitleLabel.text = title
            subtitleLabel.text = subtitle
            
            updateAppearance()
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private func setupView() {
            
            // Properties
            isUserInteractionEnabled = false
            titleLabel.adjustsFontSizeToFitWidth = true
            unselectedTitleLabel.adjustsFontSizeToFitWidth = true
            subtitleLabel.adjustsFontSizeToFitWidth = true
            
            // Override the margin
            cardControl.contentView.directionalLayoutMargins = DesignSystem.layoutMargins.itemCardControl()
            
            // Initialize Height Constraint
            heightConstraint = heightAnchor.constraint(equalToConstant: basedHeight.systemSizeMuliplier())
            heightConstraint.isActive = true
            
            // Add views
            addSubview(cardControl, withConstaintEquals: .edges)
            
            //
            let cardContentView = cardControl.contentView
            cardContentView.addSubview(unselectedTitleLabel, withConstaintEquals: [.center])
            cardContentView.addConstraints(toView: unselectedTitleLabel, withConstaintGreaterThanOrEquals: [.marginEdges])
            
            let contentStackView = UIStackView([titleLabel, subtitleLabel],
                                               axis: .vertical,
                                               distribution: .fill,
                                               alignment: .center,
                                               spacing: 2)
            
            cardContentView.addSubview(contentStackView, withConstaintEquals: [.center])
            cardContentView.addConstraints(toView: contentStackView, withConstaintGreaterThanOrEquals: [.marginEdges])
        
        }
        
        public func setupTheme() {
            
            cardControl.setupTheme()
            
            titleLabel.textStyle = textStyle.headline()
            unselectedTitleLabel.textStyle = textStyle.headline()
            subtitleLabel.textStyle = textStyle.caption2()
            
            titleLabel.textColor = currentColorTheme.componentColor.callToAction
            unselectedTitleLabel.textColor = currentColorTheme.componentColor.secondaryText
            subtitleLabel.textColor = currentColorTheme.componentColor.secondaryText
            
            heightConstraint?.constant = CGFloat(basedHeight).systemSizeMuliplier()
        }
        
        private func setLabelsToSelected(_ isSelected: Bool) {
            guard let contentSuperView = titleLabel.superview else { return }
            
            titleLabel.transform.ty = isSelected ? 0 : titleLabel.transform.ty
            unselectedTitleLabel.transform.ty = isSelected ? unselectedTitleLabel.transform.ty : 0
            
            let titleLabelInContentViewFrame = contentSuperView.convert(titleLabel.frame,
                                                                        to: cardControl.contentView)
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
            
            UIView.animate(withStyle: .normalAnimationStyle, animations: action)
        }
        
        private func updateAppearance() {
            
            switch currentState {
            case .normal:
                cardControl.currentState = .disabled
                
                setLabelsToSelected(false)
                
            case .highlighted:
                cardControl.currentState = .highlighted
                
                setLabelsToSelected(false)
                
            case .selected:
                cardControl.currentState = .normal
                
                setLabelsToSelected(true)
                
            default:
                cardControl.isHighlighted = false
                cardControl.isEnabled = false
            }
        }
    }
    
    var stackView: UIStackView
    
    static let hipticGenerator = UIImpactFeedbackGenerator(style: .light)
    
    var selectedIndex: Int = 0 {
        didSet {
            if oldValue != selectedIndex {
                SegmentedCardControl.hipticGenerator.impactOccurred()
            }
            setSelectedIndexItemCardControlSelected()
        }
    }
    
    var items: [(title: String, subtitle: String)]? {
        didSet {
            setupItems()
        }
    }
    
    var itemCardControls: [ItemCardControl]
    
    init(items: [(title: String, subtitle: String)]? = nil) {
        stackView = UIStackView()
        itemCardControls = []
        super.init(frame: .zero)
        self.items = items
        
        setupView()
        setSelectedIndexItemCardControlSelected()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(stackView, withConstaintEquals: .edges)
        
        stackView.distribution = .fillEqually
        stackView.spacing = DesignSystem.spacing.cardGutter
        stackView.isUserInteractionEnabled = false
        
        itemCardControls = []
        
        // Setup Items
        setupItems()
    }
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        var isTouchOnItemCards = false
        itemCardControls.forEach { (itemCardControl) in
            if itemCardControl.bounds.contains(touch.location(in: itemCardControl)) {
                isTouchOnItemCards = true
                itemCardControl.isHighlighted = true
            }
        }
        return isTouchOnItemCards
    }
    
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        itemCardControls.forEach { (itemCardControl) in
            itemCardControl.isHighlighted = itemCardControl.bounds.contains(touch.location(in: itemCardControl))
        }
        return bounds.contains(touch.location(in: self))
    }
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        
        guard let touch = touch else {
            return
        }
        
        var newSelectedIndex: Int?
        
        itemCardControls.forEach { (itemCardControl) in
            let isTouchOnItemCards = itemCardControl.bounds.contains(touch.location(in: itemCardControl))
            if isTouchOnItemCards {
                newSelectedIndex = itemCardControl.tag
            }
        }
        
        selectedIndex = newSelectedIndex ?? selectedIndex
        
    }
    
    override func cancelTracking(with event: UIEvent?) {
        setSelectedIndexItemCardControlSelected()
    }
    
    private func setupItems() {
        // Setup Items
        guard let items = items else { return }
        items.enumerated().forEach { (index, item) in
            let itemCardControl = ItemCardControl(title: item.title,
                                                  subtitle: item.subtitle)
            itemCardControl.tag = index
            itemCardControls.append(itemCardControl)
            stackView.addArrangedSubview(itemCardControl)
        }
    }
    
    private func setSelectedIndexItemCardControlSelected() {
        itemCardControls.forEach { (itemCardControl) in
            itemCardControl.isSelected = selectedIndex == itemCardControl.tag
            itemCardControl.isHighlighted = false
        }
    }
    
    func setupTheme() {
        stackView.arrangedSubviews.forEach { (itemCardControl) in
            guard let itemCardControl = itemCardControl as? ItemCardControl else { return }
            itemCardControl.setupTheme()
        }
    }
}
