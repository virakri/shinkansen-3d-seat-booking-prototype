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
                    return LayerStyle.button.normal
                case .highlighted:
                    return LayerStyle.button.highlighted
                case .disabled:
                    return LayerStyle.button.disabled
                default:
                    return LayerStyle.button.normal
                }
            case .outlined:
                switch state {
                case .normal:
                    return LayerStyle.outlinedButton.normal
                case .highlighted:
                    return LayerStyle.outlinedButton.highlighted
                case .disabled:
                    return LayerStyle.outlinedButton.disabled
                default:
                    return LayerStyle.outlinedButton.normal
                }
            case .text:
                return LayerStyle.none
            }
        }
        
        func textStyle() -> TextStyle {
            switch self {
            case .contained:
                return TextStyle.button
            case .outlined:
                return TextStyle.outlinedButton
            case .text:
                return TextStyle.button
            }
        }
        
        func textColor(by state: State) -> UIColor {
            switch self {
            case .contained:
                switch state {
                case .normal, .highlighted:
                    return currentColorTheme.component.contentOnCallToAction
                case .disabled:
                    return currentColorTheme.component.contentOnCallToAction
                default:
                    return currentColorTheme.component.contentOnCallToAction
                }
            case .outlined:
                switch state {
                case .normal, .highlighted:
                    return currentColorTheme.component.callToAction
                case .disabled:
                    return currentColorTheme.component.callToActionDisabled
                default:
                    return currentColorTheme.component.callToAction
                }
            case .text:
                switch state {
                case .normal, .highlighted:
                    return currentColorTheme.component.callToAction
                case .disabled:
                    return currentColorTheme.component.callToActionDisabled
                default:
                    return currentColorTheme.component.callToAction
                }
            }
        }
        
        func edgeInset() -> UIEdgeInsets {
            switch self {
            case .contained:
                return Constant.buttonEdgeInset
            case .outlined:
                return Constant.buttonOutlinedEdgeInset
            case .text:
                return Constant.buttonTextEdgeInset
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
        
        setupView()
    }
    
    override init(frame: CGRect) {
        self.type = .contained
        currentState = .normal
        super.init(frame: .zero)
        
        setupView()
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
    
    private func setupView() {
        layer.setLayer(type.layerStyle(by: currentState))
        contentEdgeInsets = type.edgeInset()
    }
    
    private func updateAppearance(animated: Bool = true) {
        var layerStyle = type.layerStyle(by: currentState)
        
        if type == .outlined {
            // Set rounded corner
            layerStyle = layerStyle.withCornerRadius(bounds.height / 2)
        }
        
        layer.setAnimatedLayer(layerStyle,
                               using: CABasicAnimationStyle.layerAnimationStyle)
        
        if let title = title(for: .normal) {
            setTitleText(title, using: type.textStyle().with(newTextColor: type.textColor(by: currentState)))
        }
    }
    
    func setTitle(_ title: String?) {
        guard let title = title else { return }
        setTitleText(title, using: type.textStyle().with(newTextColor: type.textColor(by: currentState)))
    }
}
