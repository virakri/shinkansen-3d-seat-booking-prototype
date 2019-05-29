//
//  DesignSystemViewController.swift
//  Shinkansen Tickets Booking Prototype
//
//  Created by Virakri Jinangkul on 5/27/19.
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
    
    init(withTextStyle textStyle: TextStyle, title: String) {
        super.init(frame: .zero)
        
        self.title = title
        
        contentView = TextStyleLabel(withTextStyle: textStyle)
        
        setupView()
    }
    
    init(withColor color: UIColor, title: String) {
        super.init(frame: .zero)
        
        self.title = title
        
        contentView = ColorView(withColor: color)
        
        setupView()
    }
    
    init(withLayerStylesState layerStylesState: LayerStyleView.LayerStyleState, title: String) {
        super.init(frame: .zero)
        
        self.title = title
        
        contentView = LayerStyleView(withLayerStylesState: layerStylesState)
        
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
            titleLabel.textColor = .gray
            titleLabel.font = .monospacedDigitSystemFont(ofSize: 12, weight: .medium)
            
            addArrangedSubview(titleLabel)
            addArrangedSubview(view)
            axis = .vertical
            spacing = 4
        }
    }
}

class DesignSystemView: UIView {
    
    var state: UIControl.State = .normal {
        didSet {
            for view in designSystemBlockViews {
                view.state = state
            }
        }
    }
    
    var title: String
    var designSystemBlockViews: [DesignSystemBlockView]
    var accessoryView: UIView?
    
    init(title: String, designSystemBlockViews: [DesignSystemBlockView], accessoryView: UIView? = nil) {
        self.title = title
        self.designSystemBlockViews = designSystemBlockViews
        self.accessoryView = accessoryView
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        
        var _accessoryView = UIView()
        _accessoryView = accessoryView ?? _accessoryView
        _accessoryView.isHidden = accessoryView == nil
        
        //
        let labelContainerView = UIView()
        labelContainerView.preservesSuperviewLayoutMargins = true
        labelContainerView.addSubview({
            let headlineLabel = Label()
            headlineLabel.text = title
            headlineLabel.font = .systemFont(ofSize: 36, weight: .heavy)
            return headlineLabel
        }(), withConstaintEquals: [.topSafeArea, .leadingMargin, .trailingMargin, .bottom])
        
        let scrollView = UIScrollView()
        scrollView.addSubview({
            let containerView = UIView()
            containerView.addSubview({
                let stackView =
                    UIStackView(designSystemBlockViews,
                                axis: .vertical,
                                distribution: .fill,
                                alignment: .fill,
                                spacing: 16)
                stackView.preservesSuperviewLayoutMargins = true
                return stackView
            }(), withConstaintEquals: .edges)
            containerView.preservesSuperviewLayoutMargins = true
            return containerView
        }(), withConstaintEquals: .edges,
             insetsConstant: .init(top: 0, leading: 0, bottom: 24, trailing: 0))
        scrollView.widthAnchor.constraint(equalTo: scrollView.subviews.first!.widthAnchor).isActive = true
        scrollView.preservesSuperviewLayoutMargins = true
        scrollView.alwaysBounceVertical = true
        
        //
        let stackView =
            UIStackView([labelContainerView, scrollView, _accessoryView],
                        axis: .vertical,
                        spacing: 8)
        
        stackView.preservesSuperviewLayoutMargins = true

        
        addSubview(stackView, withConstaintEquals: .edges)
        
        preservesSuperviewLayoutMargins = true
    }
}

class DesignSystemViewController: ViewController {
    
    private let dummyText = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
    
    var textStylesView: DesignSystemView!
    var ColorsView: DesignSystemView!
    var LayerStylesView: DesignSystemView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupView() {
        super.setupView()
        
        textStylesView = DesignSystemView(title: "Text Style",
                                              designSystemBlockViews: [DesignSystemBlockView(withTextStyle: .headline,
                                                                                             title: "Headline"),
                                                                       DesignSystemBlockView(withTextStyle: .subheadline,
                                                                                             title: "Subheadline"),
                                                                       DesignSystemBlockView(withTextStyle: .body,
                                                                                             title: "Body"),
                                                                       DesignSystemBlockView(withTextStyle: .caption1,
                                                                                             title: "Caption 1"),
                                                                       DesignSystemBlockView(withTextStyle: .caption2,
                                                                                             title: "Caption 2"),
                                                                       DesignSystemBlockView(withTextStyle: .button,
                                                                                             title: "Button")])
        
        ColorsView = DesignSystemView(title: "Colors",
                                          designSystemBlockViews: [DesignSystemBlockView(withColor: UIColor.accent.main,
                                                                                         title: "Accent Main"),
                                                                   DesignSystemBlockView(withColor: UIColor.accent.dark,
                                                                                         title: "Accent Dark"),
                                                                   DesignSystemBlockView(withColor: UIColor.accent.light,
                                                                                         title: "Accent Light"),
                                                                   DesignSystemBlockView(withColor: UIColor.basic.black,
                                                                                         title: "Basic Black"),
                                                                   DesignSystemBlockView(withColor: UIColor.basic.offBlack,
                                                                                         title: "Basic Off Black"),
                                                                   DesignSystemBlockView(withColor: UIColor.basic.gray,
                                                                                         title: "Basic Gray"),
                                                                   DesignSystemBlockView(withColor: UIColor.basic.offWhite,
                                                                                         title: "Basic Off White"),
                                                                   DesignSystemBlockView(withColor: UIColor.basic.white,
                                                                                         title: "Basic White"),
            ])
        
        LayerStylesView = DesignSystemView(title: "Layer Styles",
                                               designSystemBlockViews: [DesignSystemBlockView(withLayerStylesState: DesignSystemBlockView.LayerStyleView
                                                .LayerStyleState(normal: LayerStyle.card.normal,
                                                                 highlighted: LayerStyle.card.highlighted,
                                                                 disabled: LayerStyle.card.disabled,
                                                                 selected: nil,
                                                                 focused: nil) , title: "Card"),
                                                                        
                                                                        DesignSystemBlockView(withLayerStylesState: DesignSystemBlockView.LayerStyleView
                                                                            .LayerStyleState(normal: LayerStyle.largeCard.normal,
                                                                                             highlighted: LayerStyle.largeCard.highlighted,
                                                                                             disabled: LayerStyle.largeCard.disabled,
                                                                                             selected: nil,
                                                                                             focused: nil) , title: "Large Card")
                                                ,
                                                                        
                                                                        DesignSystemBlockView(withLayerStylesState: DesignSystemBlockView.LayerStyleView
                                                                            .LayerStyleState(normal: LayerStyle.button.normal,
                                                                                             highlighted: LayerStyle.button.highlighted,
                                                                                             disabled: LayerStyle.button.disabled,
                                                                                             selected: nil,
                                                                                             focused: nil) , title: "Large Card")
                                                ,
                                                                        
                                                                        DesignSystemBlockView(withLayerStylesState: DesignSystemBlockView.LayerStyleView
                                                                            .LayerStyleState(normal: LayerStyle.outlinedButton.normal,
                                                                                             highlighted: LayerStyle.outlinedButton.highlighted,
                                                                                             disabled: LayerStyle.outlinedButton.disabled,
                                                                                             selected: nil,
                                                                                             focused: nil) , title: "Large Card")
            ], accessoryView: {
                let stateContainterView = UIView()
                stateContainterView.addSubview({
                    let stateSegmentedControl = UISegmentedControl(items: ["Normal", "Highlighted","Disabled"])
                    stateSegmentedControl.selectedSegmentIndex = 0
                    stateSegmentedControl.addTarget(self, action: #selector(stateSegmentedControlValueChanged), for: .valueChanged)
                    return stateSegmentedControl
                }(), withConstaintEquals: .marginEdges)
                stateContainterView.preservesSuperviewLayoutMargins = true
                return stateContainterView
        }())
        
        let contentView = UIView()
//                contentView.addSubview(textStylesView, withConstaintEquals: .edges)
//                contentView.addSubview(ColorsView, withConstaintEquals: .edges)
        contentView.addSubview(LayerStylesView, withConstaintEquals: .edges)
        contentView.preservesSuperviewLayoutMargins = true
        
        let tabBarView: UIView = {
            let tabBarContainerView = UIView()
            tabBarContainerView.addSubview({
                let view = UIView()
                view.backgroundColor = .red
                view.translatesAutoresizingMaskIntoConstraints = false
                view.heightAnchor.constraint(equalToConstant: 48).isActive = true
                return view
            }(), withConstaintEquals: [.top, .leadingMargin, .bottomSafeArea, .trailingMargin])
            tabBarContainerView.preservesSuperviewLayoutMargins = true
            return tabBarContainerView
        }()
        tabBarView.preservesSuperviewLayoutMargins = true
        
        let stackView = UIStackView([contentView, tabBarView], axis: .vertical)
        stackView.preservesSuperviewLayoutMargins = true
        view.addSubview(stackView, withConstaintEquals: .edges)
        
        view.backgroundColor = .white
        
    }
    
    @objc func stateSegmentedControlValueChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            LayerStylesView.state = .normal
        case 1:
            LayerStylesView.state = .highlighted
        case 2:
            LayerStylesView.state = .disabled
        default:
            break
        }
    }
}
