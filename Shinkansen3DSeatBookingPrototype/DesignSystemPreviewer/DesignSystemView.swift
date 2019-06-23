//
//  DesignSystemView.swift
//  Shinkansen3DSeatBookingPrototype
//
//  Created by Virakri Jinangkul on 6/23/19.
//  Copyright © 2019 Virakri Jinangkul. All rights reserved.
//

import UIKit
import Kumi

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
        scrollView.indicatorStyle = currentColorTheme == .light ? .black : .white
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
