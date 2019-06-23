//
//  DesignSystemViewController.swift
//  Shinkansen 3D Seat Booking Prototype
//
//  Created by Virakri Jinangkul on 5/27/19.
//  Copyright © 2019 Virakri Jinangkul. All rights reserved.
//

import UIKit
import Kumi

class DesignSystemViewController: ViewController {
    
    var componentsView: DesignSystemView!
    var textStylesView: DesignSystemView!
    var colorsView: DesignSystemView!
    var layerStylesView: DesignSystemView!
    var modelContentView: DesignSystemView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupView() {
        super.setupView()
        
        componentsView = DesignSystemComponentView()
        
        colorsView = DesignSystemColorsView()
        
        textStylesView = DesignSystemTextStylesView()
        
        layerStylesView = DesignSystemLayerStylesView()
        
        modelContentView = DesignSystemView(title: "3D Content", designSystemBlockViews: [])
        
        // MARK: Layout Views
        let contentView = UIView()
        contentView.addSubview(componentsView, withConstaintEquals: .edges)
        contentView.addSubview(colorsView, withConstaintEquals: .edges)
        contentView.addSubview(textStylesView, withConstaintEquals: .edges)
        contentView.addSubview(layerStylesView, withConstaintEquals: .edges)
        contentView.addSubview(modelContentView, withConstaintEquals: .edges)
        contentView.preservesSuperviewLayoutMargins = true
        
        let tabBarControl = DesignSystemTabBarControl(items: [componentsView,
                                                              colorsView,
                                                              textStylesView,
                                                              layerStylesView,
                                                              modelContentView])
        tabBarControl.selectedIndex = 0
        tabBarControl.translatesAutoresizingMaskIntoConstraints = false
        tabBarControl.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        let tabBarView: UIView = {
            let tabBarContainerView = UIView()
            tabBarContainerView.addSubview(tabBarControl,
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
        view.addSubview(closeButton,
                        withConstaintEquals: [.trailingMargin, .topSafeArea],
                        insetsConstant: .init(top: 16))
        closeButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        closeButton.widthAnchor.constraint(equalToConstant: 44).isActive = true
        closeButton.addTarget(self,
                              action: #selector(closeButtonDidtouch(_:)), for: .touchUpInside)
    }
    
    @objc func closeButtonDidtouch(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
