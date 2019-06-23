//
//  DesignSystemBlockView.swift
//  Shinkansen3DSeatBookingPrototype
//
//  Created by Virakri Jinangkul on 6/23/19.
//  Copyright © 2019 Virakri Jinangkul. All rights reserved.
//

import UIKit
import Kumi

class DesignSystemBlockView: UIView {
    
    var state: UIControl.State = .normal {
        didSet {
            if let contentView = contentView as? LayerStyleView {
                contentView.state = state
            }
        }
    }
    
    var title: String?
    
    var contentView: UIView?
    
    init(withColor color: UIColor, title: String) {
        super.init(frame: .zero)
        
        self.title = title
        
        contentView = ColorView(withColor: color)
        
        setupView()
    }
    
    init(withTextStyle textStyle: TextStyle, title: String) {
        super.init(frame: .zero)
        
        self.title = title
        
        contentView = TextStyleLabel(withTextStyle: textStyle)
        
        setupView()
    }
    
    init(withLayerStylesState layerStylesState: LayerStyleView.LayerStyleState, title: String) {
        super.init(frame: .zero)
        
        self.title = title
        
        contentView = LayerStyleView(withLayerStylesState: layerStylesState)
        
        setupView()
    }
    
    init(withView view: UIView, title: String, constaintEquals: ConstraintEqual = .edges) {
        super.init(frame: .zero)
        
        self.title = title
        
        let contentView = UIView()
        
        contentView.addSubview(view,
                               withConstaintEquals: constaintEquals,
                               insetsConstant: .init(top: 16, leading: 16, bottom: 16, trailing: 16))
        
        self.contentView = contentView
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        
        guard let contentView = contentView else { return }
        
        let view = BlockWithHeader(title: title, view: contentView)
        
        addSubview(view,
                   withConstaintEquals: [.leadingMargin, .trailingMargin, .top, .bottom])
        
        preservesSuperviewLayoutMargins = true
    }
    
    class TextStyleLabel: Label {
        
        private let dummyText = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
        
        init(withTextStyle textStyle: TextStyle) {
            super.init(frame: .zero)
            self.textStyle = textStyle
            text = dummyText
            textColor = currentColorTheme.componentColor.primaryText
            numberOfLines = 0
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    class ColorView: UIView {
        
        init(withColor color: UIColor) {
            super.init(frame: .zero)
            translatesAutoresizingMaskIntoConstraints = false
            heightAnchor.constraint(equalToConstant: 64).isActive = true
            backgroundColor = color
            layer.borderColor = UIColor.black.cgColor
            layer.borderWidth = 1 / UIScreen.main.scale
            layer.cornerRadius = 32
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    class LayerStyleView: UIView {
        
        struct LayerStyleState {
            var normal: LayerStyle
            var highlighted: LayerStyle? = nil
            var disabled: LayerStyle? = nil
            var selected: LayerStyle? = nil
            var focused: LayerStyle? = nil
        }
        
        var state: UIControl.State = .normal {
            didSet {
                animateLayerStyle(by: state)
            }
        }
        
        var layerStylesState: LayerStyleState
        
        let layerView = UIView()
        
        init(withLayerStylesState layerStylesState: LayerStyleState) {
            self.layerStylesState = layerStylesState
            super.init(frame: .zero)
            translatesAutoresizingMaskIntoConstraints = false
            heightAnchor.constraint(equalToConstant: 128).isActive = true
            layerView.layer.setLayer(self.layerStylesState.normal)
            addSubview(layerView, withConstaintEquals: .edges, insetsConstant: .init(top: 12, leading: 0, bottom: 12, trailing: 0))
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private func animateLayerStyle(by state: UIControl.State) {
            let animationStyle = CABasicAnimationStyle(duration: 0.35,
                                                       delay: 0,
                                                       timingFunction: .init(controlPoints: 0, 0, 0.2, 1))
            switch state {
            case .normal:
                layerView.layer.setAnimatedLayer(layerStylesState.normal, using: animationStyle)
            case .highlighted:
                layerView.layer.setAnimatedLayer(layerStylesState.highlighted ?? layerStylesState.normal, using: animationStyle)
            case .disabled:
                layerView.layer.setAnimatedLayer(layerStylesState.disabled ?? layerStylesState.normal, using: animationStyle)
            case .focused:
                layerView.layer.setAnimatedLayer(layerStylesState.focused ?? layerStylesState.normal, using: animationStyle)
            case .selected:
                layerView.layer.setAnimatedLayer(layerStylesState.selected ?? layerStylesState.normal, using: animationStyle)
            default:
                break
            }
        }
    }
    
    class BlockWithHeader: UIStackView {
        
        var title: String?
        
        var view: UIView
        
        init(title: String?, view: UIView) {
            self.title = title
            self.view = view
            super.init(frame: .zero)
            setupView()
        }
        
        required init(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func setupView() {
            
            let titleLabel = UILabel()
            titleLabel.text = title
            titleLabel.textColor = .lightGray
            titleLabel.font = .monospacedDigitSystemFont(ofSize: 12, weight: .medium)
            
            addArrangedSubview(titleLabel)
            addArrangedSubview(view)
            axis = .vertical
            spacing = 4
        }
    }
}
