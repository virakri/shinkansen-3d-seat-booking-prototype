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
    
    var designSystemButton: Button!
    
    var startPrototypeButton: Button!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(UIFontMetrics(forTextStyle: .body).scaledFont(for: .systemFont(ofSize: 1)))
        
        print(UIFontMetrics(forTextStyle: .headline).scaledFont(for: UIFont.systemFont(ofSize: 24, weight: .light)).pointSize)
        
        print(UIFontMetrics(forTextStyle: .largeTitle).scaledFont(for: UIFont.systemFont(ofSize: 24, weight: .light)).pointSize)
        
        print(UIFontMetrics(forTextStyle: .caption1).scaledFont(for: UIFont.systemFont(ofSize: 24, weight: .light)).pointSize)
   print(CGFloat(1).systemSizeMuliplier())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        present(DesignSystemViewController(), animated: true, completion: nil)
    }
    
    override func setupView() {
        super.setupView()
        
        // MARK: Initialize views
        textStackView = UIStackView()
        callToActionStackView = UIStackView()
        
        headlineLabel = Label()
        bodyLabel = Label()
        
        designSystemButton = Button(type: .text)
        startPrototypeButton = Button(type: .contained)
        
        // MARK: Setup static views' properties
        textStackView.axis = .vertical
        callToActionStackView.axis = .vertical
        
        headlineLabel.numberOfLines = 0
        bodyLabel.numberOfLines = 0
        
        // MARK: Setup stackViews in view
        view.addSubview(textStackView, withConstaintEquals: [.topSafeArea, .leadingMargin, .trailingMargin], insetsConstant: .init(top: 24, leading: 0, bottom: 0, trailing: 0))
        
        view.addSubview(callToActionStackView, withConstaintEquals: [.leadingMargin, .trailingMargin], insetsConstant: .zero)
        
        view.constraintBottomSafeArea(to: callToActionStackView, withMinimumConstant: 16)
        
        // MARK: Add labels into stackViews
        textStackView.addArrangedSubview(headlineLabel)
        textStackView.addArrangedSubview(bodyLabel)
        
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
        
        
        print("This is prototype initializer")
        
        
        // MARK: Update Theme for views
        designSystemButton.setupTheme()
        startPrototypeButton.setupTheme()
        
        // MARK: Set spacing for stackViews
        textStackView.spacing = min(CGFloat(20).systemSizeMuliplier(), 24)
        callToActionStackView.spacing = min(CGFloat(16).systemSizeMuliplier(), 20)
        
        // MARK: Set Text Styles for labels
        headlineLabel.textStyle = textStyle.largeTitle()
        bodyLabel.textStyle = textStyle.body()
        
        // MARK: Set Colors for labels
    }
    
    override func setupInteraction() {
        super.setupInteraction()
        
        // MARK: Add targets to buttons
        designSystemButton.addTarget(self, action: #selector(designSystemButtonDidTouch(_:)), for: .touchUpInside)
        startPrototypeButton.addTarget(self, action: #selector(startPrototypeButtonDidTouch(_:)), for: .touchUpInside)
        
    }
    
    @objc private func designSystemButtonDidTouch(_ sender: Button) {
        
        present(DesignSystemViewController(), animated: true, completion: nil)
    }
    
    @objc private func startPrototypeButtonDidTouch(_ sender: Button) {
        
        present(UINavigationController(rootViewController: BookingCriteriaViewController()), animated: true, completion: nil)
    }
}
