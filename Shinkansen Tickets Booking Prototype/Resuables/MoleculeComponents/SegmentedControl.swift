//
//  SegmentedControl.swift
//  Shinkansen Tickets Booking Prototype
//
//  Created by Virakri Jinangkul on 6/10/19.
//  Copyright © 2019 Virakri Jinangkul. All rights reserved.
//

import UIKit

class SegmentedControl: UIControl {
    
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
    
    var itemCardControls: [SegmentedItemControl]
    
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
            let itemCardControl = SegmentedItemControl(title: item.title,
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
            guard let itemCardControl = itemCardControl as? SegmentedItemControl else { return }
            itemCardControl.setupTheme()
        }
    }
}
