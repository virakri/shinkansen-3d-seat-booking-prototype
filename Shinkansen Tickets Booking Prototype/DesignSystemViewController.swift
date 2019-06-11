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
            headlineLabel.textColor = currentColorTheme.componentColor.primaryText
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
            DesignSystemView(title: "Components",
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
                                
                                DesignSystemBlockView(withView: {
                                    let segmentedControl =
                                        SegmentedControl(items: [(title: "Item 1", subtitle: "Lorem Ipsum"),
                                            (title: "Item 2", subtitle: "Lorem Ipsum"),
                                            (title: "Item 3", subtitle: "Lorem Ipsum")])
                                    segmentedControl.translatesAutoresizingMaskIntoConstraints = false
                                    return segmentedControl
                                }(), title: "Segmented Card Control",
                                     constaintEquals: [.leading, .top, .bottom]),
                                
                                DesignSystemBlockView(withView: {
                                    let headlineLabelSetView =
                                        HeadlineLabelSetView(title: "Lorem ipsum dolor",
                                                             subtitle: "Lorem ipsum dolor",
                                                             textAlignment: .left)
                                    return headlineLabelSetView
                                }(), title: "Headline Label Set View",
                                     constaintEquals: .edges),
                                
                                DesignSystemBlockView(withView: {
                                    let subheadlineLabelSet =
                                        SubheadlineLabelSetView(title: "Lorem ipsum dolor",
                                                                subtitle: "Lorem ipsum dolor",
                                                                textAlignment: .left)
                                    return subheadlineLabelSet
                                }(), title: "Subheadline Label Set View",
                                     constaintEquals: .edges),
                                
                                DesignSystemBlockView(withView: {
                                    let labelSetView =
                                        LabelSetView(type: .regular,
                                                     title: "Lorem ipsum dolor",
                                                     subtitle: "Lorem ipsum dolor",
                                                     textAlignment: .left)
                                    return labelSetView
                                }(), title: "Label Set View Regular",
                                     constaintEquals: .edges),
                                
                                DesignSystemBlockView(withView: {
                                    let labelSetView =
                                        LabelSetView(type: .small,
                                                     title: "Lorem ipsum dolor",
                                                     subtitle: "Lorem ipsum dolor",
                                                     textAlignment: .left)
                                    return labelSetView
                                }(), title: "Label Set View Small",
                                     constaintEquals: .edges),
                                
                                DesignSystemBlockView(withView: {
                                    let stationPairView =
                                        StationPairView(fromStation: "Bangkok", fromTime: "9:12",
                                                        toStation: "Osaka", toTime: "12:43")
                                    return stationPairView
                                }(), title: "Station Pair View",
                                     constaintEquals: .edges),
                                
                                DesignSystemBlockView(withView: {
                                    let descriptionSetView =
                                        DescriptionSetView(trainNumber: "Sakura 123",
                                                           trainName: "E5 Series",
                                                           carNumber: "Car 8",
                                                           className: "GreenCar",
                                                           seatNumber: "15C",
                                                           price: "$14,200")
                                    return descriptionSetView
                                }(), title: "Description Set View",
                                     constaintEquals: .edges),
                                
                                DesignSystemBlockView(withView: {
                                    let headerRouteInformationView =
                                        HeaderRouteInformationView(fromStation: "Bangkok", fromTime: "9:12",
                                                                   toStation: "Osaka", toTime: "12:43",
                                                                   trainNumber: "Sakura 123",
                                                                   trainName: "E5 Series",
                                                                   carNumber: "Car 8",
                                                                   className: "GreenCar",
                                                                   seatNumber: "15C",
                                                                   price: "$14,200")
                                    return headerRouteInformationView
                                }(), title: "Description Set View",
                                     constaintEquals: .edges),
                                
                                DesignSystemBlockView(withView: {
                                    let trainScheduleTableViewCell =
                                        TrainScheduleTableViewCell(style: .default, reuseIdentifier: nil)
                                    trainScheduleTableViewCell.setupValue(time: "9:46 - 11:42",
                                                                          amountOfTime: "3hr 12min",
                                                                          trainNumber: "Hayabusa 231",
                                                                          trainName: "E6 Series",
                                                                          price: "$13,930",
                                                                          trainImage: #imageLiteral(resourceName: "e7-series"))
                                    let trainScheduleTableViewCellContentView = trainScheduleTableViewCell.contentView
                                    return trainScheduleTableViewCellContentView
                                }(), title: "Train Schedule Table View Cell",
                                     constaintEquals: .edges),
                                
                                DesignSystemBlockView(withView: {
                                    let seatClassTableViewCell =
                                        SeatClassTableViewCell(style: .default, reuseIdentifier: nil)
                                    seatClassTableViewCell
                                        .setupValue(seatClassType: .green,
                                                    seatClassName: "GranClass",
                                                    price: "¥24,000",
                                                    description: "a first class travel with an experience of luxury ",
                                                    seatImage: nil)
                                    let seatClassTableViewCellContentView = seatClassTableViewCell.contentView
                                    return seatClassTableViewCellContentView
                                }(), title: "Seat Class Table View Cell",
                                     constaintEquals: .edges),
//
                                ])
        
        
        textStylesView = DesignSystemView(title: "Text Style",
                                          designSystemBlockViews: [
                                            DesignSystemBlockView(withTextStyle: textStyle.largeTitle(),
                                                                  title: "Large Title"),
                                            DesignSystemBlockView(withTextStyle: textStyle.headline(),
                                                                  title: "Headline"),
                                            DesignSystemBlockView(withTextStyle: textStyle.subheadline(),
                                                                  title: "Subheadline"),
                                            DesignSystemBlockView(withTextStyle: textStyle.body(),
                                                                  title: "Body"),
                                            DesignSystemBlockView(withTextStyle: textStyle.button(),
                                                                  title: "Button"),
                                            DesignSystemBlockView(withTextStyle: textStyle.outlinedButton(),
                                                                  title: "Outlined Button"),
                                            DesignSystemBlockView(withTextStyle: textStyle.footnote(),
                                                                  title: "Footnote"),
                                            DesignSystemBlockView(withTextStyle: textStyle.caption1(),
                                                                  title: "Caption 1"),
                                            DesignSystemBlockView(withTextStyle: textStyle.caption2(),
                                                                  title: "Caption 2")])
        
        colorsView = DesignSystemView(title: "Colors",
                                      designSystemBlockViews: [
                                        DesignSystemBlockView(withColor: UIColor.accent().main,
                                                              title: "Accent Main"),
                                        DesignSystemBlockView(withColor: UIColor.accent().dark,
                                                              title: "Accent Dark"),
                                        DesignSystemBlockView(withColor: UIColor.accent().light,
                                                              title: "Accent Light"),
                                        DesignSystemBlockView(withColor: UIColor.basic.black,
                                                              title: "Basic Black"),
                                        DesignSystemBlockView(withColor: UIColor.basic.offBlack,
                                                              title: "Basic Off Black"),
                                        DesignSystemBlockView(withColor: UIColor.basic().gray,
                                                              title: "Basic Gray"),
                                        DesignSystemBlockView(withColor: UIColor.basic.offWhite,
                                                              title: "Basic Off White"),
                                        DesignSystemBlockView(withColor: UIColor.basic.white,
                                                              title: "Basic White"),
            ])
        
        layerStylesView = DesignSystemView(title: "Layer Styles",
                                           designSystemBlockViews: [
                                            DesignSystemBlockView(withLayerStylesState: DesignSystemBlockView.LayerStyleView
                                                .LayerStyleState(normal: layerStyle.button.normal(),
                                                                 highlighted: layerStyle.button.highlighted(),
                                                                 disabled: layerStyle.button.disabled(),
                                                                 selected: nil,
                                                                 focused: nil) , title: "Contained Button")
                                            ,
                                            
                                            DesignSystemBlockView(withLayerStylesState: DesignSystemBlockView.LayerStyleView
                                                .LayerStyleState(normal: layerStyle.outlinedButton.normal(),
                                                                 highlighted: layerStyle.outlinedButton.highlighted(),
                                                                 disabled: layerStyle.outlinedButton.disabled(),
                                                                 selected: nil,
                                                                 focused: nil) , title: "Outlined Button")
                                            ,
                                            DesignSystemBlockView(withLayerStylesState: DesignSystemBlockView.LayerStyleView
                                                .LayerStyleState(normal: layerStyle.card.normal(),
                                                                 highlighted: layerStyle.card.highlighted(),
                                                                 disabled: layerStyle.card.disabled(),
                                                                 selected: nil,
                                                                 focused: nil) , title: "Card"),
                                            
                                            DesignSystemBlockView(withLayerStylesState: DesignSystemBlockView.LayerStyleView
                                                .LayerStyleState(normal: layerStyle.largeCard.normal(),
                                                                 highlighted: layerStyle.largeCard.highlighted(),
                                                                 disabled: layerStyle.largeCard.disabled(),
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
        
        let closeButton = ImageButton(image: #imageLiteral(resourceName: "symbol-close-button"))
        view.addSubview(closeButton, withConstaintEquals: [.trailingMargin, .topSafeArea])
        closeButton.addTarget(self, action: #selector(closeButtonDidtouch(_:)), for: .touchUpInside)
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
    
    @objc func closeButtonDidtouch(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
