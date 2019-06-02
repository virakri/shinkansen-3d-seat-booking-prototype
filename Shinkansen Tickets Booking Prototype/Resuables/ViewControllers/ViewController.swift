//
//  ViewController.swift
//  Shinkansen Tickets Booking Prototype
//
//  Created by Virakri Jinangkul on 5/28/19.
//  Copyright © 2019 Virakri Jinangkul. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return currentColorTheme.statusBarStyle
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register for `UIContentSizeCategory.didChangeNotification`
        NotificationCenter.default.addObserver(self, selector: #selector(preferredContentSizeChanged(_:)), name: UIContentSizeCategory.didChangeNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(preferredColorThemeChanged(_:)), name: .didColorThemeChange, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(preferredBoldTextStatusChanged(_:)), name: UIAccessibility.boldTextStatusDidChangeNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(preferredColorThemeChanged(_:)), name: UIAccessibility.darkerSystemColorsStatusDidChangeNotification, object: nil)
        
        setupView()
        setupInteraction()
        setupTheme()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    deinit {
        // Remove NotificationCenter Deinit
        NotificationCenter.default.removeObserver(self)
    }
    
    /// Puts together all components into view in viewController. Supposed to be called only in `viewDidLoad()`.
    internal func setupView() {
        
    }
    
    /// Setups all stylings, sizes, and colors. It needs to be first called after `setupView()`, and it is called whenever `UIContentSizeCategory` or `.didColorThemeChange` notification is called.
    internal func setupTheme() {
        
        setNeedsStatusBarAppearanceUpdate()
        view.backgroundColor = currentColorTheme.componentColor.background
        view.tintColor = currentColorTheme.componentColor.callToAction
        
    }
    
    /// Initializes interactions and gestures in the view controller.
    internal func setupInteraction() {
        
    }
    
    @objc func preferredContentSizeChanged(_ notification: Notification) {
        setupTheme()
    }
    
    @objc func preferredBoldTextStatusChanged(_ notification: Notification) {
        setupTheme()
    }
    
    @objc func preferredColorThemeChanged(_ notification: Notification) {
        setupTheme()
    }
}
