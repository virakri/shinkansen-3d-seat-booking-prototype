//
//  DesignSystemTabBarControl.swift
//  Shinkansen3DSeatBookingPrototype
//
//  Created by Virakri Jinangkul on 6/23/19.
//  Copyright © 2019 Virakri Jinangkul. All rights reserved.
//

import UIKit
import Kumi

class DesignSystemTabBarControl: UIControl {
    
    class TabButton: UIControl {
        
        var tabIndex: Int?
        
        var title: String? {
            didSet {
                titleLabel.text = title
            }
        }
        
        private var titleLabel: UILabel
        
        override var isSelected: Bool {
            didSet {
                UIView.animate(withDuration: isSelected ? 0 : 0.15, animations: {
                    self.alpha = self.isSelected ? 1 : 0.33
                })
            }
        }
        
        override var isHighlighted: Bool {
            didSet {
                UIView.animate(withDuration: isHighlighted ? 0 : 0.15, animations: {
                    self.titleLabel.alpha = self.isHighlighted ? 0.5 : 1
                })
            }
        }
        
        override init(frame: CGRect) {
            titleLabel = UILabel()
            super.init(frame: .zero)
            
            titleLabel.font = .systemFont(ofSize: 10, weight: .bold)
            titleLabel.textColor = currentColorTheme.componentColor.callToAction
            
            addSubview(titleLabel, withConstaintEquals: .edges)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    var selectedIndex: Int = 0 {
        didSet {
            sendActions(for: .valueChanged)
            tabButtons.forEach { $0.isSelected = $0.tabIndex == selectedIndex }
            items.enumerated().forEach {
                (index: Int, item: DesignSystemView) in
                item.isHidden = index != selectedIndex
            }
        }
    }
    
    private var tabButtons: [TabButton]
    
    private var items: [DesignSystemView]
    
    init(items: [DesignSystemView]) {
        tabButtons = []
        self.items = items
        super.init(frame: .zero)
        
        setupView(with: self.items)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView(with items: [DesignSystemView]) {
        
        items.enumerated().forEach { (index: Int, item: DesignSystemView)  in
            let button = TabButton()
            button.title = item.title
            button.isSelected = false
            button.tabIndex = index
            item.tag = index
            button.addTarget(self, action: #selector(tabButtonDidTouch), for: .touchUpInside)
            tabButtons.append(button)
        }
        
        selectedIndex = 0
        
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        
        addSubview(stackView, withConstaintEquals: .edges)
        
        tabButtons.forEach { (button) in
            stackView.addArrangedSubview(button)
        }
    }
    
    @objc func tabButtonDidTouch(_ sender: TabButton) {
        guard let tabIndex = sender.tabIndex else { return }
        selectedIndex = tabIndex
    }
}
