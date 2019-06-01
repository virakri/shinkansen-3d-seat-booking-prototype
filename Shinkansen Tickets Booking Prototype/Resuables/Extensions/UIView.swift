//
//  UIView.swift
//  Shinkansen Tickets Booking Prototype
//
//  Created by Virakri Jinangkul on 5/27/19.
//  Copyright © 2019 Virakri Jinangkul. All rights reserved.
//

import UIKit

struct ConstraintEqual : OptionSet {
    let rawValue: Int
    init(rawValue: Int) { self.rawValue = rawValue }
    static let top = ConstraintEqual(rawValue: 1 << 0)
    static let leading = ConstraintEqual(rawValue: 1 << 1)
    static let bottom = ConstraintEqual(rawValue: 1 << 2)
    static let trailing = ConstraintEqual(rawValue: 1 << 3)
    
    static let topMargin = ConstraintEqual(rawValue: 1 << 4)
    static let leadingMargin = ConstraintEqual(rawValue: 1 << 5)
    static let bottomMargin = ConstraintEqual(rawValue: 1 << 6)
    static let trailingMargin = ConstraintEqual(rawValue: 1 << 7)
    
    static let topSafeArea = ConstraintEqual(rawValue: 1 << 8)
    static let leadingSafeArea = ConstraintEqual(rawValue: 1 << 9)
    static let bottomSafeArea = ConstraintEqual(rawValue: 1 << 10)
    static let trailingSafeArea = ConstraintEqual(rawValue: 1 << 11)
    
    static let centerVertical = ConstraintEqual(rawValue: 1 << 12)
    static let centerHorizontal = ConstraintEqual(rawValue: 1 << 13)
    
    static let edges:ConstraintEqual = [top, leading, bottom, trailing]
    static let marginEdges:ConstraintEqual = [topMargin, leadingMargin, bottomMargin, trailingMargin]
    static let safeAreaEdges:ConstraintEqual = [topSafeArea, leadingSafeArea, bottomSafeArea, trailingSafeArea]
    static let center:ConstraintEqual = [centerVertical, centerHorizontal]
}

extension UIView {
    
    convenience init(containingView: UIView,
                     withConstaintEquals equals: ConstraintEqual,
                     insetsConstant: NSDirectionalEdgeInsets = .zero) {
        self.init(frame: .zero)
        addSubview(containingView, withConstaintEquals: equals,
                   insetsConstant: insetsConstant)
    }
    
    @discardableResult
    func addSubview(_ view: UIView,
                    withConstaintEquals equals: ConstraintEqual,
                    insetsConstant: NSDirectionalEdgeInsets = .zero ) -> Self {
        addSubview(view)
        
        guard !equals.isEmpty else { return self }
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        if equals.contains(.top) {
            view.topAnchor.constraint(equalTo: topAnchor,
                                      constant: insetsConstant.top).isActive = true
        }
        
        if equals.contains(.bottom) {
            view.bottomAnchor.constraint(equalTo: bottomAnchor,
                                         constant: -insetsConstant.bottom).isActive = true
        }
        
        if equals.contains(.leading) {
            view.leadingAnchor.constraint(equalTo: leadingAnchor,
                                          constant: insetsConstant.leading).isActive = true
        }
        
        if equals.contains(.trailing) {
            view.trailingAnchor.constraint(equalTo: trailingAnchor,
                                           constant:  -insetsConstant.trailing).isActive = true
        }
        
        if equals.contains(.topMargin) {
            view.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor,
                                      constant: insetsConstant.top).isActive = true
        }
        
        if equals.contains(.bottomMargin) {
            view.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor,
                                         constant: -insetsConstant.bottom).isActive = true
        }
        
        if equals.contains(.leadingMargin) {
            view.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor,
                                          constant: insetsConstant.leading).isActive = true
        }
        
        if equals.contains(.trailingMargin) {
            view.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor,
                                           constant:  -insetsConstant.trailing).isActive = true
        }
        
        
        if equals.contains(.topSafeArea) {
            view.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor,
                                      constant: insetsConstant.top).isActive = true
        }
        
        if equals.contains(.bottomSafeArea) {
            view.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor,
                                         constant: -insetsConstant.bottom).isActive = true
        }
        
        if equals.contains(.leadingSafeArea) {
            view.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor,
                                          constant: insetsConstant.leading).isActive = true
        }
        
        if equals.contains(.trailingSafeArea) {
            view.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor,
                                           constant:  -insetsConstant.trailing).isActive = true
        }
        
        
        if equals.contains(.centerVertical) {
            view.safeAreaLayoutGuide.centerYAnchor.constraint(equalTo: centerYAnchor,
                                                              constant: 0).isActive = true
        }
        
        if equals.contains(.centerHorizontal) {
            view.safeAreaLayoutGuide.centerXAnchor.constraint(equalTo:centerXAnchor,
                                                              constant: 0).isActive = true
        }
        // for chaining function
        return self
    }
    
    @discardableResult
    func constraintAllEdges(to view: UIView) -> [NSLayoutConstraint] {
        let topConstraint = self.topAnchor.constraint(equalTo: view.topAnchor)
        let bottomConstraint = self.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        let leadingConstraint = self.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        let trailingAnchor = self.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        
        let anchors = [topConstraint, bottomConstraint,
                       leadingConstraint, trailingAnchor]
        NSLayoutConstraint.activate(anchors)
        return anchors
    }
    
    @discardableResult
    func constraintBottomSafeArea(to view: UIView, withMinimumConstant constant: CGFloat) -> [NSLayoutConstraint] {
        
        let bottomConstraint = self.bottomAnchor.constraint(greaterThanOrEqualTo: view.bottomAnchor, constant: constant)
        
        let bottomSafeAreaConstraint = self.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        bottomSafeAreaConstraint.priority = .defaultHigh
        
        let anchors = [bottomConstraint, bottomSafeAreaConstraint]
        
        NSLayoutConstraint.activate(anchors)
        
        return anchors
    }
}
