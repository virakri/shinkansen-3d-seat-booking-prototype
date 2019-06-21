//
//  PrototypeInitialViewController.swift
//  Shinkansen Tickets Booking Prototype
//
//  Created by Virakri Jinangkul on 5/14/19.
//  Copyright © 2019 Virakri Jinangkul. All rights reserved.
//

import UIKit

class PrototypeInitialViewController: ViewController {
    
    var textStackView: UIStackView!
    
    var callToActionStackView: UIStackView!
    
    var headlineLabel: Label!
    
    var bodyLabel: Label!
    
    var colorThemeSegmentedControl: InitialViewColorThemeSegmentedControl!
    
    var colorThemeSegmentedControlContainerView: UIView!
    
    var designSystemButton: InitialViewButton!
    
    var startPrototypeButton: InitialViewButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func setupView() {
        super.setupView()
        
        // MARK: Initialize views
        textStackView = UIStackView()
        callToActionStackView = UIStackView()
        
        headlineLabel = Label()
        bodyLabel = Label()
        
        colorThemeSegmentedControl = InitialViewColorThemeSegmentedControl()
        
        colorThemeSegmentedControlContainerView = UIView()
        colorThemeSegmentedControlContainerView.preservesSuperviewLayoutMargins = true
        colorThemeSegmentedControlContainerView
            .addSubview(colorThemeSegmentedControl,
                        withConstaintEquals: [.topMargin, .bottomMargin, .center],
                        insetsConstant: .init(vertical: 8,
                                              horizontal: 0) )
        colorThemeSegmentedControlContainerView
            .addConstraints(toView: colorThemeSegmentedControl,
                            withConstaintGreaterThanOrEquals: .marginEdges)
        
        designSystemButton = InitialViewButton(type: .text)
        startPrototypeButton = InitialViewButton(type: .contained)
        
        // MARK: Setup static views' properties
        textStackView.axis = .vertical
        callToActionStackView.axis = .vertical
        callToActionStackView.preservesSuperviewLayoutMargins = true
        
        headlineLabel.numberOfLines = 0
        bodyLabel.numberOfLines = 0
        
        // MARK: Setup stackViews in view
        view.addSubview(textStackView,
                        withConstaintEquals: [.topSafeArea, .centerHorizontal],
                        insetsConstant: .init(top: 24, trailing: 0))
        
        view.addConstraints(toView: textStackView,
                            withConstaintGreaterThanOrEquals: [.leadingMargin, .trailingMargin])
        
        let textStackViewWidthConstraint = textStackView.widthAnchor.constraint(equalToConstant: DesignSystem.layout.maximumWidth)
        textStackViewWidthConstraint.priority = .defaultHigh
        textStackViewWidthConstraint.isActive = true
        
        view.addSubview(callToActionStackView,
                        withConstaintEquals: [.centerHorizontal])
        
        view.addConstraints(toView: callToActionStackView,
                            withConstaintGreaterThanOrEquals: [.leadingMargin, .trailingMargin])
        
        let callToActionStackViewWidthConstraint =
            callToActionStackView
                .widthAnchor
                .constraint(equalToConstant: DesignSystem.layout.maximumWidth)
        callToActionStackViewWidthConstraint.priority = .defaultHigh
        callToActionStackViewWidthConstraint.isActive = true
        
        view.constraintBottomSafeArea(to: callToActionStackView,
                                      withGreaterThanConstant: 16)
        
        
        // MARK: Add labels into stackViews
        textStackView.addArrangedSubview(headlineLabel)
        textStackView.addArrangedSubview(bodyLabel)
        
        
        callToActionStackView.addArrangedSubview(colorThemeSegmentedControlContainerView)
        callToActionStackView.addArrangedSubview(designSystemButton)
        callToActionStackView.addArrangedSubview(startPrototypeButton)
        
        // MARK: Setup static content
        headlineLabel.text = "Lorem ipsum dolor sit amet"
        bodyLabel.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. "
        
        designSystemButton.setTitle("Explore Design System")
        startPrototypeButton.setTitle("Start the Prototype")
        
    }
    
    override func setupTheme() {
        super.setupTheme()
        
        // MARK: Override background color
        view.backgroundColor = UIColor.accent().main
        
        // MARK: Update Theme for views
        designSystemButton.setupTheme()
        startPrototypeButton.setupTheme()
        colorThemeSegmentedControl.tintColor = UIColor.basic.white
        colorThemeSegmentedControlContainerView.backgroundColor = UIColor.accent().light
        colorThemeSegmentedControlContainerView.layer.cornerRadius = DesignSystem.radiusCorner.card()
        
        // MARK: Set spacing for stackViews
        textStackView.spacing = min(CGFloat(20).systemSizeMuliplier(), 24)
        callToActionStackView.spacing = min(CGFloat(16).systemSizeMuliplier(), 20)
        
        // MARK: Set Text Styles for labels
        headlineLabel.textStyle = textStyle.largeTitle()
        bodyLabel.textStyle = textStyle.body()
        
        // MARK: Set Colors for labels
        headlineLabel.textColor = UIColor.basic.white
        bodyLabel.textColor = UIColor.basic.white
    }
    
    override func setupInteraction() {
        super.setupInteraction()
        
        // MARK: Initialize state of user interfaces
        colorThemeSegmentedControl.selectedIndex = currentColorTheme == .light ? 0 : 1
        
        // MARK: Add targets to buttons
        designSystemButton.addTarget(self, action: #selector(designSystemButtonDidTouch(_:)), for: .touchUpInside)
        startPrototypeButton.addTarget(self, action: #selector(startPrototypeButtonDidTouch(_:)), for: .touchUpInside)
        
        colorThemeSegmentedControl.addTarget(self, action: #selector(colorThemeSegmentedControlValueChanged(_:)), for: .valueChanged)
        
    }
    
    @objc private func designSystemButtonDidTouch(_ sender: Button) {
        
        present(DesignSystemViewController(), animated: true, completion: nil)
    }
    
    @objc private func startPrototypeButtonDidTouch(_ sender: Button) {
        
        let presentedViewController = NavigationController(rootViewController: BookingCriteriaViewController())
        presentedViewController.modalPresentationStyle = .fullScreen
        
        present(presentedViewController, animated: true, completion: nil)
    }
    
    @objc private func colorThemeSegmentedControlValueChanged(_ sender: InitialViewColorThemeSegmentedControl) {
        switch sender.selectedIndex {
        case 0:
            currentColorTheme = .light
        case 1:
            currentColorTheme = .dark
        default:
            break
        }
    }
}
