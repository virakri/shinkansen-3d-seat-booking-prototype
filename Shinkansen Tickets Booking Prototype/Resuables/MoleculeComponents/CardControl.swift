//
//  CardControl.swift
//  Shinkansen Tickets Booking Prototype
//
//  Created by Virakri Jinangkul on 5/30/19.
//  Copyright © 2019 Virakri Jinangkul. All rights reserved.
//

import UIKit
import Kumi

class CardControl: UIControl {
    enum _Type {
        case regular
        case large
        
        func layerStyle(by state: State) -> LayerStyle {
            switch self {
            case .regular:
                switch state {
                case .normal:
                    return LayerStyle.card.normal
                case .highlighted:
                    return LayerStyle.card.highlighted
                case .disabled:
                    return LayerStyle.card.disabled
                default:
                    return LayerStyle.card.normal
                }
            case .large:
                switch state {
                case .normal:
                    return LayerStyle.largeCard.normal
                case .highlighted:
                    return LayerStyle.largeCard.highlighted
                case .disabled:
                    return LayerStyle.largeCard.disabled
                default:
                    return LayerStyle.largeCard.normal
                }
            }
        }
        
        func layoutMargin() -> NSDirectionalEdgeInsets {
            switch self {
            case .regular:
                return Constant.cardLayoutMarginInset
            case .large:
                return Constant.largeCardLayoutMarginInset
            }
        }
    }
    
    public var contentView: UIView
    
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
        contentView = UIView()
        self.type = type
        currentState = .normal
        super.init(frame: .zero)
        
        setupView()
    }
    
    override init(frame: CGRect) {
        contentView = UIView()
        self.type = .regular
        currentState = .normal
        super.init(frame: .zero)
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        contentView.clipsToBounds = true
        contentView.isUserInteractionEnabled = false
        contentView.directionalLayoutMargins = type.layoutMargin()
        addSubview(contentView, withConstaintEquals: .edges)
        contentView.layer.setLayer(type.layerStyle(by: currentState).withShadowStyle(ShadowStyle.noShadow))
        layer.setLayer(type.layerStyle(by: currentState))
    }
    
    private func updateAppearance(animated: Bool = true) {
        contentView.layer.setAnimatedLayer(type.layerStyle(by: currentState).withShadowStyle(ShadowStyle.noShadow),
                               using: CABasicAnimationStyle.layerAnimationStyle)
        layer.setAnimatedLayer(type.layerStyle(by: currentState),
                               using: CABasicAnimationStyle.layerAnimationStyle)
        
    }
}
