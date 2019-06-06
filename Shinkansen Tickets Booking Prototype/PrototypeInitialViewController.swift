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
    
    var darkModeSwitch: UISwitch!
    
    var darkModeSwitchLabel: Label!
    
    var designSystemButton: Button!
    
    var startPrototypeButton: Button!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func setupView() {
        super.setupView()
        
        // MARK: Initialize views
        textStackView = UIStackView()
        callToActionStackView = UIStackView()
        
        headlineLabel = Label()
        bodyLabel = Label()
        
        darkModeSwitch = UISwitch()
        darkModeSwitchLabel = Label()
        
        designSystemButton = Button(type: .text)
        startPrototypeButton = Button(type: .contained)
        
        // MARK: Setup static views' properties
        textStackView.axis = .vertical
        callToActionStackView.axis = .vertical
        callToActionStackView.alignment = .center
        
        headlineLabel.numberOfLines = 0
        bodyLabel.numberOfLines = 0
        
        // MARK: Setup stackViews in view
        view.addSubview(textStackView, withConstaintEquals: [.topSafeArea, .leadingMargin, .trailingMargin], insetsConstant: .init(top: 24, leading: 0, bottom: 0, trailing: 0))
        
        view.addSubview(callToActionStackView, withConstaintEquals: [.leadingMargin, .trailingMargin], insetsConstant: .zero)
        
        view.constraintBottomSafeArea(to: callToActionStackView, withGreaterThanConstant: 16)
        
        // MARK: Set container view for switch
        let switchStackView = UIStackView([darkModeSwitch, darkModeSwitchLabel], distribution: .fill, alignment: .center, spacing: 8)
        
        // MARK: Add labels into stackViews
        textStackView.addArrangedSubview(headlineLabel)
        textStackView.addArrangedSubview(bodyLabel)
        
        
        callToActionStackView.addArrangedSubview(switchStackView)
        callToActionStackView.addArrangedSubview(designSystemButton)
        callToActionStackView.addArrangedSubview(startPrototypeButton)
        
        // MARK: Setup static content
        headlineLabel.text = "Lorem ipsum dolor sit amet"
        bodyLabel.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. "
        
        darkModeSwitchLabel.text = "Dark Mode"
        
        designSystemButton.setTitle("Explore Design System")
        startPrototypeButton.setTitle("Start the Prototype")
        
    }
    
    override func setupTheme() {
        super.setupTheme()
        
        // MARK: Update Theme for views
        designSystemButton.setupTheme()
        startPrototypeButton.setupTheme()
        
        // MARK: Set spacing for stackViews
        textStackView.spacing = min(CGFloat(20).systemSizeMuliplier(), 24)
        callToActionStackView.spacing = min(CGFloat(16).systemSizeMuliplier(), 20)
        
        // MARK: Set Text Styles for labels
        headlineLabel.textStyle = textStyle.largeTitle()
        bodyLabel.textStyle = textStyle.body()
        
        darkModeSwitchLabel.textStyle = textStyle.body()
        
        // MARK: Set Colors for labels
        headlineLabel.textColor = currentColorTheme.componentColor.primaryText
        bodyLabel.textColor = currentColorTheme.componentColor.secondaryText
        
        darkModeSwitchLabel.textColor = currentColorTheme.componentColor.secondaryText
    }
    
    override func setupInteraction() {
        super.setupInteraction()
        
        // MARK: Initialize state of user interfaces
        darkModeSwitch.isOn = currentColorTheme == .dark
        
        // MARK: Add targets to buttons
        designSystemButton.addTarget(self, action: #selector(designSystemButtonDidTouch(_:)), for: .touchUpInside)
        startPrototypeButton.addTarget(self, action: #selector(startPrototypeButtonDidTouch(_:)), for: .touchUpInside)
        
        darkModeSwitch.addTarget(self, action: #selector(darkModeSwitchValueChanged(_:)), for: .valueChanged)
        
    }
    
    @objc private func designSystemButtonDidTouch(_ sender: Button) {
        
        present(DesignSystemViewController(), animated: true, completion: nil)
    }
    
    @objc private func startPrototypeButtonDidTouch(_ sender: Button) {
        
        let presentedViewController = NavigationController(rootViewController: BookingCriteriaViewController())
        presentedViewController.modalPresentationStyle = .fullScreen
        
        present(presentedViewController, animated: true, completion: nil)
    }
    
    @objc private func darkModeSwitchValueChanged(_ sender: UISwitch) {
        currentColorTheme = sender.isOn ? .dark : .light
    }
}
