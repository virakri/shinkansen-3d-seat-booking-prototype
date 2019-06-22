//
//  PrototypeInitialViewController.swift
//  Shinkansen 3D Seat Booking Prototype
//
//  Created by Virakri Jinangkul on 5/14/19.
//  Copyright © 2019 Virakri Jinangkul. All rights reserved.
//

import UIKit
import SafariServices

class PrototypeInitialViewController: ViewController {
    
    var textStackView: UIStackView!
    
    var callToActionStackView: UIStackView!
    
    var headlineLabel: Label!
    
    var bodyLabel: Label!
    
    var colorThemeSegmentedControl: InitialViewColorThemeSegmentedControl!
    
    var colorThemeSegmentedControlContainerView: UIView!
    
    var gitHubButton: InitialViewButton!
    
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
                        withConstaintEquals: [.topMargin,
                                              .bottomMargin,
                                              .centerHorizontal],
                        insetsConstant: .init(vertical: 8,
                                              horizontal: 0) )
        colorThemeSegmentedControlContainerView
            .addConstraints(toView: colorThemeSegmentedControl,
                            withConstaintGreaterThanOrEquals: .marginEdges)
        gitHubButton = InitialViewButton(type: .text)
        gitHubButton.addTarget(self, action: #selector(openGitHub), for: .touchUpInside)
        designSystemButton = InitialViewButton(type: .text)
        startPrototypeButton = InitialViewButton(type: .contained)
        
        // MARK: Setup static views' properties
        textStackView.axis = .vertical
        callToActionStackView.axis = .vertical
        callToActionStackView.preservesSuperviewLayoutMargins = true
        
        headlineLabel.numberOfLines = 0
        bodyLabel.numberOfLines = 0
        
        // MARK: Setup Scroll View
        let textStackViewContainerView = UIView(containingView: textStackView,
                                                withConstaintEquals: [.topSafeArea,
                                                                      .leadingMargin,
                                                                      .trailingMargin,
                                                                      .bottom],
                                                insetsConstant: .init(top: 24))
        textStackViewContainerView.preservesSuperviewLayoutMargins = true

        let textScrollView = UIScrollView()
        textScrollView.addSubview(textStackViewContainerView,
                                  withConstaintEquals: [.edges])
        textScrollView
            .widthAnchor
            .constraint(equalTo: textStackViewContainerView
                .widthAnchor)
            .isActive = true

        textScrollView.preservesSuperviewLayoutMargins = true
        textScrollView.indicatorStyle = .white
        
        // MARK: Setup stackViews and scrollView in view
        view.addSubview(textScrollView,
                        withConstaintEquals: [.topSafeArea])
        
        view.addConstraints(toView: textScrollView,
                            withConstaintGreaterThanOrEquals: [.leading, .trailing])

        let textScrollViewWidthConstraint = textScrollView.widthAnchor.constraint(equalToConstant: DesignSystem.layout.maximumWidth)
        textScrollViewWidthConstraint.priority = .defaultHigh
        textScrollViewWidthConstraint.isActive = true
        
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
                                      withGreaterThanConstant: 16,
                                      minimunConstant: 8)
        
        // MARK: Add labels into stackViews
        textStackView.addArrangedSubview(headlineLabel)
        textStackView.addArrangedSubview(bodyLabel)
        
        callToActionStackView.addArrangedSubview(colorThemeSegmentedControlContainerView)
        let textButtonStackView = UIStackView([gitHubButton,
                                               designSystemButton],
                                              axis: .vertical,
                                              spacing: 4)
        callToActionStackView.addArrangedSubview(textButtonStackView)
        callToActionStackView.addArrangedSubview(startPrototypeButton)
        
        callToActionStackView.topAnchor.constraint(equalTo: textScrollView.bottomAnchor, constant: 16).isActive = true
        
        
        // MARK: Setup static content
        headlineLabel.text = "Welcome to 3D Seat Booking Prototype!"
        bodyLabel.text = """
Thank you for your interest in this prototype!
This prototype shows the potential usage of 3D visualization capability in booking and reservation products.
As this is a prototype, the information showing is mock data which statically stores in the app. That means the information doesn’t obtain from or send back to the server, and many functionalities don’t fully work. (Particularly, the route picker and date picker in the first view.)
To start the prototype please tap on "Start this Prototype" button, and to exit the prototype in the middle of the flow, shake your device and the exiting prompt will show up.\nThis prototype is an open-source project, so feel free to visit project's GitHub repository to learn more or contribute. "GitHub Repository" button down there will direct you to the repository.
If you have any further question or feedback, please contact me by sending feedback via TestFlight feedback or direct message via Twitter [@virakri](https://www.twitter.com/virakri).
Thank you,
V Jinangkul
"""
        bodyLabel.isUserInteractionEnabled = true
        gitHubButton.setTitle("GitHub Repository")
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
        colorThemeSegmentedControl.setupTheme()
        colorThemeSegmentedControlContainerView.backgroundColor = UIColor.accent().light
        colorThemeSegmentedControlContainerView.layer.cornerRadius = DesignSystem.radiusCorner.card()
        
        // MARK: Set spacing for stackViews
        textStackView.spacing = min(CGFloat(20).systemSizeMuliplier(), 24)
        callToActionStackView.spacing = min(CGFloat(16).systemSizeMuliplier(), 20)
        
        // MARK: Set Text Styles for labels
        headlineLabel.textStyle = textStyle.largeTitle()
        bodyLabel.textStyle = textStyle.body().with(newParagraphSpacing: (textStyle.body().font.pointSize +
            (textStyle.body().lineSpacing ?? 0)) * 0.75)
        
        // MARK: Set Colors for labels
        headlineLabel.textColor = UIColor.basic.white
        bodyLabel.textColor = UIColor.basic.white
    }
    
    override func setupInteraction() {
        super.setupInteraction()
        
        // MARK: Initialize state of user interfaces
        colorThemeSegmentedControl.selectedIndex = currentColorTheme == .light ? 0 : 1
        colorThemeSegmentedControl.setFeedbackGeneratorEnabled()
        
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
        presentedViewController.transitioningDelegate = self
        
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
    
    @objc private func openGitHub() {
        let vc = SFSafariViewController(url: URL(string: "https://github.com/virakri/shinkansen-tickets-booking-prototype")!)
        vc.modalPresentationStyle = .pageSheet
        present(vc, animated: true, completion: nil)
    }
}

// MARK: - PrototypeInitialViewControllerTransitioningDelegate

extension PrototypeInitialViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let transition =  PrototypeInitialViewControllerAnimatedTransition()
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let transition =  PrototypeInitialViewControllerAnimatedTransition()
        return transition
    }
}
