//
//  InitialViewColorThemeSegmentedControl.swift
//  Shinkansen Tickets Booking Prototype
//
//  Created by Virakri Jinangkul on 6/20/19.
//  Copyright © 2019 Virakri Jinangkul. All rights reserved.
//

import UIKit

class InitialViewColorThemeItemControl: UIControl {
    
    enum ColorThemeType {
        case light
        case dark
        
        func text() -> String {
            switch self {
            case .light:
                return "Light Mode"
            case .dark:
                return "Dark Mode"
            }
        }
        
        func iconTintColor() -> UIColor {
            switch self {
            case .light:
                return UIColor.accent().main
            case .dark:
                return UIColor.basic.white
            }
        }
        
        func iconBackgroundColor() -> UIColor {
            switch self {
            case .light:
                return UIColor.basic.white
            case .dark:
                return UIColor.accent().main
            }
        }
    }
    
    private var colorThemeType: ColorThemeType
    
    private var iconImageView: UIImageView
    
    private var titleLabel: Label
    
    private var checkMarkIconImageView: UIImageView
    
    override var isHighlighted: Bool {
        didSet {
            let scaleFactor: CGFloat = isHighlighted ? 0.98 : 1
            
            UIView.animate(withStyle: .normalAnimationStyle,
                           animations: {
                            self.alpha =
                                self.isHighlighted ?
                                    DesignSystem.alpha.highlighted : 1
                            self.transform =
                                CGAffineTransform(scaleX: scaleFactor,
                                                  y: scaleFactor)
            })
        }
    }
    
    override var isSelected: Bool {
        didSet {
            checkMarkIconImageView.image = isSelected ? #imageLiteral(resourceName: "iconCheckedSymbol") : #imageLiteral(resourceName: "iconUncheckedSymbol")
            
            let scaleFactor: CGFloat = isSelected ? 1 : 0.8
            
            UIView.animate(withStyle: .normalAnimationStyle,
                           animations: {
                            self.iconImageView.alpha =
                                self.isSelected ?
                                    1 : DesignSystem.alpha.disabled
                            self.titleLabel.alpha =
                                self.isSelected ?
                                    1 : DesignSystem.alpha.disabled
                            self.iconImageView.transform =
                                CGAffineTransform(scaleX: scaleFactor,
                                                  y: scaleFactor)
            })
        }
    }
    
    init(colorThemeType: ColorThemeType) {
        self.colorThemeType = colorThemeType
        iconImageView = UIImageView(image: #imageLiteral(resourceName: "colorThemeModeIcon"))
        titleLabel = Label()
        checkMarkIconImageView = UIImageView()
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        tintColor = UIColor.basic.white
        
        iconImageView.tintColor = colorThemeType.iconTintColor()
        iconImageView.backgroundColor = colorThemeType.iconBackgroundColor()
        iconImageView.layer.borderColor = UIColor.basic.white.cgColor
        iconImageView.layer.borderWidth = 1
        iconImageView.layer.cornerRadius = 4
        
        titleLabel.text = colorThemeType.text()
        titleLabel.textStyle = textStyle.caption1()
        titleLabel.textColor = UIColor.basic.white
        
        let mainStackView = UIStackView([iconImageView,
                                         titleLabel,
                                         checkMarkIconImageView],
                                        axis: .vertical,
                                        distribution: .fill,
                                        alignment: .center,
                                        spacing: 8)
        
        addSubview(mainStackView, withConstaintEquals: .edges)
    }
}

class InitialViewColorThemeSegmentedControl: UIControl {
    
    private var _selectedIndex: Int = 0
    
    var selectedIndex: Int {
        get {
            return _selectedIndex
        }set{
            if selectedIndex != newValue {
                _selectedIndex = newValue
                sendActions(for: .valueChanged)
            }
            setSelectedIndexItemControl()
        }
    }
    
    private var mainStackView: UIStackView!
    
    private var colorThemeItemControls: [InitialViewColorThemeItemControl]!
    
    init() {
        super.init(frame: .zero)
        setupItems()
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupItems() {
        colorThemeItemControls =
            [InitialViewColorThemeItemControl(colorThemeType: .light),
             InitialViewColorThemeItemControl(colorThemeType: .dark)]
        colorThemeItemControls[0].tag = 0
        colorThemeItemControls[1].tag = 1
    }
    
    private func setupView() {
        mainStackView = UIStackView(colorThemeItemControls,
                                    axis: .horizontal,
                                    spacing: 40)
        mainStackView.isUserInteractionEnabled = false
        addSubview(mainStackView, withConstaintEquals: .edges)
    }
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        var isTouchOnItem = false
        colorThemeItemControls.forEach { (colorThemeItemControl) in
            if colorThemeItemControl.bounds.contains(touch.location(in: colorThemeItemControl)) {
                isTouchOnItem = true
                colorThemeItemControl.isHighlighted = true
            }
        }
        return isTouchOnItem
    }
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        
        guard let touch = touch else {
            return
        }
        
        var newSelectedIndex: Int?
        
        colorThemeItemControls.forEach { (colorThemeItemControl) in
            let isTouchOnItemCards =
                colorThemeItemControl
                .bounds
                .contains(touch
                    .location(in: colorThemeItemControl))
            if isTouchOnItemCards &&
                colorThemeItemControl
                    .isEnabled {
                newSelectedIndex =
                    colorThemeItemControl.tag
            }
        }
        selectedIndex = newSelectedIndex ?? selectedIndex
    }
    
    override func cancelTracking(with event: UIEvent?) {
        setSelectedIndexItemControl()
    }
    
    private func setSelectedIndexItemControl() {
        colorThemeItemControls.forEach { (colorThemeItemControl) in
            colorThemeItemControl.isSelected =
                selectedIndex == colorThemeItemControl.tag && colorThemeItemControl.isEnabled
            colorThemeItemControl.isHighlighted = false
        }
    }
}
