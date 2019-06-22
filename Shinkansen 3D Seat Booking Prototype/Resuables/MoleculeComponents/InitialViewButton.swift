//
//  InitialViewButton.swift
//  Shinkansen 3D Seat Booking Prototype
//
//  Created by Virakri Jinangkul on 6/20/19.
//  Copyright © 2019 Virakri Jinangkul. All rights reserved.
//

import UIKit
import Kumi

class InitialViewButton: Button {
    
    enum InitialViewType {
        case contained
        case text
        
        func layerStyle(by state: State) -> LayerStyle {
            switch self {
            case .contained:
                switch state {
                case .normal:
                    return DesignSystem
                        .layerStyle
                        .button
                        .normal()
                        .withBackgroundColor(UIColor.basic.white.cgColor)
                case .highlighted:
                    return DesignSystem
                        .layerStyle
                        .button
                        .normal()
                        .withBackgroundColor(UIColor.accent().light.cgColor)
                case .disabled:
                    return DesignSystem
                        .layerStyle
                        .button
                        .normal()
                        .withBackgroundColor(UIColor.basic.white.cgColor)
                default:
                    return DesignSystem
                        .layerStyle
                        .button
                        .normal()
                        .withBackgroundColor(UIColor.basic.white.cgColor)
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
            case .text:
                return DesignSystem.textStyle.button()
            }
        }
        
        func textColor(by state: State) -> UIColor {
            switch self {
            case .contained:
                switch state {
                case .normal, .highlighted:
                    return UIColor.accent().main
                case .disabled:
                    return UIColor.basic().gray
                default:
                    return UIColor.accent().main
                }
            case .text:
                switch state {
                case .normal, .highlighted:
                    return UIColor.basic.white
                case .disabled:
                    return UIColor.basic().gray
                default:
                    return UIColor.basic.white
                }
            }
        }
        
        func edgeInset() -> UIEdgeInsets {
            switch self {
            case .contained:
                return DesignSystem.edgeInsets.button()
            case .text:
                return .init(vertical: 12,
                             horizontal: 12)
            }
        }
    }
    
    fileprivate var type: InitialViewType
    
     init(type: InitialViewType) {
        self.type = type
        super.init(frame: .zero)
        setupTheme()
        currentState = .normal
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateAppearance(animated: Bool = true) {
        let layerStyle = type.layerStyle(by: currentState)
        
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
    
    override func setupTheme()  {
        contentEdgeInsets = type.edgeInset()
        layer.setLayer(type.layerStyle(by: currentState))
        setTitle(titleLabel?.text)
    }
    
    override func setTitle(_ title: String?) {
        guard let title = title else { return }
        setTitleText(title, using: type.textStyle().with(newTextColor: type.textColor(by: currentState)))
    }
    
}
