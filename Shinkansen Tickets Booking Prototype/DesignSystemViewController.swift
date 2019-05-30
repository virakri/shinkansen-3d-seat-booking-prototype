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
            textColor = currentColorTheme.component.primaryText
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
            headlineLabel.textColor = currentColorTheme.component.primaryText
            headlineLabel.font = .systemFont(ofSize: 36, weight: .heavy)
            return headlineLabel
        }(), withConstaintEquals: [.topSafeArea, .leadingMargin, .trailingMargin, .bottom],
             insetsConstant: .init(top: 16, leading: 0, bottom: 0, trailing: 0))
        
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

class DesignSystemTabBar: UIControl {
    
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
            
            titleLabel.font = .systemFont(ofSize: 15, weight: .bold)
            titleLabel.textColor = currentColorTheme.component.callToAction
            
            addSubview(titleLabel, withConstaintEquals: .edges)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    var selectedIndex: Int = 0 {
        didSet {
            sendActions(for: .valueChanged)
            tabButtons.forEach { (button) in
                button.isSelected = button.tabIndex == selectedIndex
            }
        }
    }
    
    fileprivate var tabButtons: [TabButton]
    
    init(items: [String]) {
        tabButtons = []
        super.init(frame: .zero)
        
        setupView(with: items)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView(with items: [String]) {
        
        items.enumerated().forEach { (index: Int, item: String)  in
            let button = TabButton()
            button.title = item
            button.isSelected = false
            button.tabIndex = index
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

class DesignSystemViewController: ViewController {
    
    var componentsView: DesignSystemView!
    var textStylesView: DesignSystemView!
    var colorsView: DesignSystemView!
    var layerStylesView: DesignSystemView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupView() {
        super.setupView()
        
        componentsView =
            DesignSystemView(title: "Components Style",
                             designSystemBlockViews: [
                                DesignSystemBlockView(withView: {
                                    let button = Button(type: .contained)
                                    button.setTitle("Lorem Ipsum")
                                    return button
                                }(),title: "Contained Button",
                                    constaintEquals: [.top, .bottom, .centerHorizontal]),
                                
                                DesignSystemBlockView(withView: {
                                    let button = Button(type: .outlined)
                                    button.setTitle("Lorem Ipsum")
                                    return button
                                }(), title: "Outlined Button",
                                     constaintEquals: [.top, .bottom, .centerHorizontal]),
                                
                                DesignSystemBlockView(withView: {
                                    let cardControl = CardControl(type: .regular)
                                    cardControl.translatesAutoresizingMaskIntoConstraints = false
                                    cardControl.heightAnchor.constraint(equalToConstant: 112).isActive = true
                                    return cardControl
                                }(), title: "Card",
                                     constaintEquals: .edges),
                                
                                DesignSystemBlockView(withView: {
                                    let cardControl = CardControl(type: .large)
                                    cardControl.translatesAutoresizingMaskIntoConstraints = false
                                    cardControl.heightAnchor.constraint(equalToConstant: 112).isActive = true
                                    return cardControl
                                }(), title: "Large Card",
                                     constaintEquals: .edges),
                                
                                
                                DesignSystemBlockView(withTextStyle: .body,
                                                      title: "Body"),
                                DesignSystemBlockView(withTextStyle: .caption1,
                                                      title: "Caption 1"),
                                DesignSystemBlockView(withTextStyle: .caption2,
                                                      title: "Caption 2"),
                                DesignSystemBlockView(withTextStyle: .button,
                                                      title: "Button")])
        
        textStylesView = DesignSystemView(title: "Text Style",
                                          designSystemBlockViews: [
                                            DesignSystemBlockView(withTextStyle: .headline,
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
        
        colorsView = DesignSystemView(title: "Colors",
                                      designSystemBlockViews: [
                                        DesignSystemBlockView(withColor: UIColor.accent.main,
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
        
        layerStylesView = DesignSystemView(title: "Layer Styles",
                                           designSystemBlockViews: [
                                            DesignSystemBlockView(withLayerStylesState: DesignSystemBlockView.LayerStyleView
                                                .LayerStyleState(normal: LayerStyle.button.normal,
                                                                 highlighted: LayerStyle.button.highlighted,
                                                                 disabled: LayerStyle.button.disabled,
                                                                 selected: nil,
                                                                 focused: nil) , title: "Contained Button")
                                            ,
                                            
                                            DesignSystemBlockView(withLayerStylesState: DesignSystemBlockView.LayerStyleView
                                                .LayerStyleState(normal: LayerStyle.outlinedButton.normal,
                                                                 highlighted: LayerStyle.outlinedButton.highlighted,
                                                                 disabled: LayerStyle.outlinedButton.disabled,
                                                                 selected: nil,
                                                                 focused: nil) , title: "Outlined Button")
                                            ,
                                            DesignSystemBlockView(withLayerStylesState: DesignSystemBlockView.LayerStyleView
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
        contentView.addSubview(componentsView, withConstaintEquals: .edges)
        contentView.addSubview(textStylesView, withConstaintEquals: .edges)
        contentView.addSubview(colorsView, withConstaintEquals: .edges)
        contentView.addSubview(layerStylesView, withConstaintEquals: .edges)
        contentView.preservesSuperviewLayoutMargins = true
        
        let tabBar = DesignSystemTabBar(items: ["Components", "Colors", "Text Styles", "Layer Styles"])
        tabBar.addTarget(self, action: #selector(tabBarValueChanged), for: .valueChanged)
        tabBar.selectedIndex = 0
        tabBar.translatesAutoresizingMaskIntoConstraints = false
        tabBar.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        let tabBarView: UIView = {
            let tabBarContainerView = UIView()
            tabBarContainerView.addSubview(tabBar,
                                           withConstaintEquals: [.top,
                                                                 .leadingMargin,
                                                                 .bottomSafeArea,
                                                                 .trailingMargin])
            tabBarContainerView.preservesSuperviewLayoutMargins = true
            return tabBarContainerView
        }()
        tabBarView.preservesSuperviewLayoutMargins = true
        
        let stackView = UIStackView([contentView, tabBarView], axis: .vertical)
        stackView.preservesSuperviewLayoutMargins = true
        view.addSubview(stackView, withConstaintEquals: .edges)
        
    }
    
    @objc func stateSegmentedControlValueChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            layerStylesView.state = .normal
        case 1:
            layerStylesView.state = .highlighted
        case 2:
            layerStylesView.state = .disabled
        default:
            break
        }
    }
    
    @objc func tabBarValueChanged(_ sender: DesignSystemTabBar) {
        componentsView.isHidden = true
        textStylesView.isHidden = true
        colorsView.isHidden = true
        layerStylesView.isHidden = true
        
        switch sender.selectedIndex {
        case 0:
            componentsView.isHidden = false
        case 1:
            colorsView.isHidden = false
        case 2:
            textStylesView.isHidden = false
        case 3:
            layerStylesView.isHidden = false
        default:
            break
        }
    }
}
