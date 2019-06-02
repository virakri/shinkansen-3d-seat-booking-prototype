//
//  Button.swift
//  Shinkansen Tickets Booking Prototype
//
//  Created by Virakri Jinangkul on 5/29/19.
//  Copyright © 2019 Virakri Jinangkul. All rights reserved.
//

import UIKit
import Kumi

class Button: UIButton {
    
    enum _Type {
        case contained
        case outlined
        case text
        
        func layerStyle(by state: State) -> LayerStyle {
            switch self {
            case .contained:
                switch state {
                case .normal:
                    return DesignSystem.layerStyle.button.normal()
                case .highlighted:
                    return DesignSystem.layerStyle.button.highlighted()
                case .disabled:
                    return DesignSystem.layerStyle.button.disabled()
                default:
                    return DesignSystem.layerStyle.button.normal()
                }
            case .outlined:
                switch state {
                case .normal:
                    return DesignSystem.layerStyle.outlinedButton.normal()
                case .highlighted:
                    return DesignSystem.layerStyle.outlinedButton.highlighted()
                case .disabled:
                    return DesignSystem.layerStyle.outlinedButton.disabled()
                default:
                    return DesignSystem.layerStyle.outlinedButton.normal()
                }
            case .text:
                switch state {
                case .normal:
                    return LayerStyle(opacity: 1)
                case .highlighted:
                    return LayerStyle(opacity: DesignSystem.opacity.highlighted)
                case .disabled:
                    return LayerStyle(opacity: 1)
                default:
                    return LayerStyle(opacity: 1)
                }
            }
        }
        
        func textStyle() -> TextStyle {
            switch self {
            case .contained:
                return DesignSystem.textStyle.button()
            case .outlined:
                return DesignSystem.textStyle.outlinedButton()
            case .text:
                return DesignSystem.textStyle.button()
            }
        }
        
        func textColor(by state: State) -> UIColor {
            switch self {
            case .contained:
                switch state {
                case .normal, .highlighted:
                    return currentColorTheme.componentColor.contentOnCallToAction
                case .disabled:
                    return currentColorTheme.componentColor.contentOnCallToAction
                default:
                    return currentColorTheme.componentColor.contentOnCallToAction
                }
            case .outlined:
                switch state {
                case .normal, .highlighted:
                    return currentColorTheme.componentColor.callToAction
                case .disabled:
                    return currentColorTheme.componentColor.callToActionDisabled
                default:
                    return currentColorTheme.componentColor.callToAction
                }
            case .text:
                switch state {
                case .normal, .highlighted:
                    return currentColorTheme.componentColor.callToAction
                case .disabled:
                    return currentColorTheme.componentColor.callToActionDisabled
                default:
                    return currentColorTheme.componentColor.callToAction
                }
            }
        }
        
        func edgeInset() -> UIEdgeInsets {
            switch self {
            case .contained:
                return DesignSystem.edgeInsets.button()
            case .outlined:
                return DesignSystem.edgeInsets.outlinedButton()
            case .text:
                return DesignSystem.edgeInsets.button()
            }
        }
    }
    
    override var isEnabled: Bool {
        didSet {
            currentState = isEnabled ? .normal : .disabled
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            currentState = isHighlighted ? .highlighted : .normal
        }
    }
    
    fileprivate var currentState: State {
        didSet {
            updateAppearance()
        }
    }
    
    fileprivate var type: _Type
    
    init(type: _Type) {
        self.type = type
        currentState = .normal
        super.init(frame: .zero)
        setupTheme()
    }
    
    override init(frame: CGRect) {
        self.type = .contained
        currentState = .normal
        super.init(frame: .zero)
        setupTheme()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        if type == .outlined {
            // Set rounded corner
            layer.cornerRadius = bounds.height / 2
        }
    }
    
    private func updateAppearance(animated: Bool = true) {
        
        var layerStyle = type.layerStyle(by: currentState)
        
        if type == .outlined {
            // Set rounded corner
            layerStyle = layerStyle.withCornerRadius(bounds.height / 2)
        }
        
        if animated {
            layer.setAnimatedLayer(layerStyle,
                                   using: CABasicAnimationStyle.layerAnimationStyle)
        } else {
            layer.setLayer(layerStyle)
        }
        
        if let title = title(for: .normal) {
            setTitleText(title, using: type.textStyle().with(newTextColor: type.textColor(by: currentState)))
        }
    }
    
    public func setupTheme() {
        contentEdgeInsets = type.edgeInset()
        layer.setLayer(type.layerStyle(by: currentState))
        setTitle(titleLabel?.text)
    }
    
    public func setTitle(_ title: String?) {
        guard let title = title else { return }
        setTitleText(title, using: type.textStyle().with(newTextColor: type.textColor(by: currentState)))
    }
}
