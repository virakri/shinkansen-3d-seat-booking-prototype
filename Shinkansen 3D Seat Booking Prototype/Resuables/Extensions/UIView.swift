//
//  UIView.swift
//  Shinkansen 3D Seat Booking Prototype
//
//  Created by Virakri Jinangkul on 5/27/19.
//  Copyright © 2019 Virakri Jinangkul. All rights reserved.
//

import UIKit
import Kumi

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
    
    static let centerVerticalMargin = ConstraintEqual(rawValue: 1 << 14)
    static let centerHorizontalMargin = ConstraintEqual(rawValue: 1 << 15)
    
    static let centerVerticalSafeArea = ConstraintEqual(rawValue: 1 << 16)
    static let centerHorizontalSafeArea = ConstraintEqual(rawValue: 1 << 17)
    
    static let edges: ConstraintEqual = [top, leading, bottom, trailing]
    static let marginEdges: ConstraintEqual = [topMargin, leadingMargin, bottomMargin, trailingMargin]
    static let safeAreaEdges: ConstraintEqual = [topSafeArea, leadingSafeArea, bottomSafeArea, trailingSafeArea]
    static let center: ConstraintEqual = [centerVertical, centerHorizontal]
    static let centerMargin: ConstraintEqual = [centerVerticalMargin, centerHorizontalMargin]
    static let centerSafeArea: ConstraintEqual = [centerVerticalSafeArea, centerHorizontalSafeArea]
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
            view.centerYAnchor.constraint(equalTo: centerYAnchor,
                                          constant: insetsConstant.top - insetsConstant.bottom).isActive = true
        }
        
        if equals.contains(.centerHorizontal) {
            view.centerXAnchor.constraint(equalTo:centerXAnchor,
                                          constant: insetsConstant.leading - insetsConstant.trailing).isActive = true
        }
        
        
        if equals.contains(.centerVerticalMargin) {
            view.centerYAnchor.constraint(equalTo: layoutMarginsGuide.centerYAnchor,
                                          constant: insetsConstant.top - insetsConstant.bottom).isActive = true
        }
        
        if equals.contains(.centerHorizontalMargin) {
            view.centerXAnchor.constraint(equalTo: layoutMarginsGuide.centerXAnchor,
                                          constant: insetsConstant.leading - insetsConstant.trailing).isActive = true
        }
        
        
        if equals.contains(.centerVerticalSafeArea) {
            view.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor,
                                          constant: insetsConstant.top - insetsConstant.bottom).isActive = true
        }
        
        if equals.contains(.centerHorizontalSafeArea) {
            view.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor,
                                          constant: insetsConstant.leading - insetsConstant.trailing).isActive = true
        }
        // for chaining function
        return self
    }
    
    func addConstraints(toView view: UIView,
                        withConstaintEquals equals: ConstraintEqual,
                        insetsConstant: NSDirectionalEdgeInsets = .zero) {
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
            view.centerYAnchor.constraint(equalTo: centerYAnchor,
                                          constant: insetsConstant.top - insetsConstant.bottom).isActive = true
        }
        
        if equals.contains(.centerHorizontal) {
            view.centerXAnchor.constraint(equalTo:centerXAnchor,
                                          constant: insetsConstant.leading - insetsConstant.trailing).isActive = true
        }
        
        
        if equals.contains(.centerVerticalMargin) {
            view.centerYAnchor.constraint(equalTo: layoutMarginsGuide.centerYAnchor,
                                          constant: insetsConstant.top - insetsConstant.bottom).isActive = true
        }
        
        if equals.contains(.centerHorizontalMargin) {
            view.centerXAnchor.constraint(equalTo: layoutMarginsGuide.centerXAnchor,
                                          constant: insetsConstant.leading - insetsConstant.trailing).isActive = true
        }
        
        
        if equals.contains(.centerVerticalSafeArea) {
            view.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor,
                                          constant: insetsConstant.top - insetsConstant.bottom).isActive = true
        }
        
        if equals.contains(.centerHorizontalSafeArea) {
            view.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor,
                                          constant: insetsConstant.leading - insetsConstant.trailing).isActive = true
        }
    }
    
    func addConstraints(toView view: UIView,
                        withConstaintGreaterThanOrEquals greaterThanOrEquals: ConstraintEqual,
                        insetsConstant: NSDirectionalEdgeInsets = .zero) {
        view.translatesAutoresizingMaskIntoConstraints = false
        
        if greaterThanOrEquals.contains(.top) {
            view.topAnchor.constraint(greaterThanOrEqualTo: topAnchor,
                                      constant: insetsConstant.top).isActive = true
        }
        
        if greaterThanOrEquals.contains(.bottom) {
            view.bottomAnchor.constraint(greaterThanOrEqualTo: bottomAnchor,
                                         constant: -insetsConstant.bottom).isActive = true
        }
        
        if greaterThanOrEquals.contains(.leading) {
            view.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor,
                                          constant: insetsConstant.leading).isActive = true
        }
        
        if greaterThanOrEquals.contains(.trailing) {
            trailingAnchor.constraint(greaterThanOrEqualTo: view.trailingAnchor,
                                           constant:  insetsConstant.trailing).isActive = true
        }
        
        if greaterThanOrEquals.contains(.topMargin) {
            view.topAnchor.constraint(greaterThanOrEqualTo: layoutMarginsGuide.topAnchor,
                                      constant: insetsConstant.top).isActive = true
        }
        
        if greaterThanOrEquals.contains(.bottomMargin) {
            bottomAnchor.constraint(greaterThanOrEqualTo: view.layoutMarginsGuide.bottomAnchor,
                                         constant: insetsConstant.bottom).isActive = true
        }
        
        if greaterThanOrEquals.contains(.leadingMargin) {
            view.leadingAnchor.constraint(greaterThanOrEqualTo: layoutMarginsGuide.leadingAnchor,
                                          constant: insetsConstant.leading).isActive = true
        }
        
        if greaterThanOrEquals.contains(.trailingMargin) {
            trailingAnchor.constraint(greaterThanOrEqualTo: view.layoutMarginsGuide.trailingAnchor,
                                           constant:  insetsConstant.trailing).isActive = true
        }
        
        
        if greaterThanOrEquals.contains(.topSafeArea) {
            view.topAnchor.constraint(greaterThanOrEqualTo: safeAreaLayoutGuide.topAnchor,
                                      constant: insetsConstant.top).isActive = true
        }
        
        if greaterThanOrEquals.contains(.bottomSafeArea) {
            bottomAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor,
                                         constant: insetsConstant.bottom).isActive = true
        }
        
        if greaterThanOrEquals.contains(.leadingSafeArea) {
            view.leadingAnchor.constraint(greaterThanOrEqualTo: safeAreaLayoutGuide.leadingAnchor,
                                          constant: insetsConstant.leading).isActive = true
        }
        
        if greaterThanOrEquals.contains(.trailingSafeArea) {
            trailingAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.trailingAnchor,
                                           constant:  insetsConstant.trailing).isActive = true
        }
        
        if greaterThanOrEquals.contains(.centerVertical) {
            view.centerYAnchor.constraint(greaterThanOrEqualTo: centerYAnchor,
                                                              constant: 0).isActive = true
        }
        
        if greaterThanOrEquals.contains(.centerHorizontal) {
            view.centerXAnchor.constraint(greaterThanOrEqualTo: centerXAnchor,
                                                              constant: 0).isActive = true
        }
    }
    
//    @discardableResult
//    func constraintAllEdges(to view: UIView) -> [NSLayoutConstraint] {
//        let topConstraint = self.topAnchor.constraint(equalTo: view.topAnchor)
//        let bottomConstraint = self.bottomAnchor.constraint(equalTo: view.bottomAnchor)
//        let leadingConstraint = self.leadingAnchor.constraint(equalTo: view.leadingAnchor)
//        let trailingAnchor = self.trailingAnchor.constraint(equalTo: view.trailingAnchor)
//
//        let anchors = [topConstraint, bottomConstraint,
//                       leadingConstraint, trailingAnchor]
//        NSLayoutConstraint.activate(anchors)
//        return anchors
//    }
    
    @discardableResult
    func constraintBottomSafeArea(to view: UIView,
                                  withGreaterThanConstant greaterThanConstant: CGFloat,
                                  minimunConstant: CGFloat = 0) -> [NSLayoutConstraint] {
        
        let bottomConstraint = self
            .bottomAnchor
            .constraint(greaterThanOrEqualTo: view.bottomAnchor,
                        constant: greaterThanConstant > greaterThanConstant ? greaterThanConstant : greaterThanConstant)
        
        let bottomSafeAreaConstraint = self
            .safeAreaLayoutGuide
            .bottomAnchor
            .constraint(equalTo: view.bottomAnchor,
                        constant: minimunConstant)
        bottomSafeAreaConstraint.priority = .defaultHigh
        
        let anchors = [bottomConstraint, bottomSafeAreaConstraint]
        
        NSLayoutConstraint.activate(anchors)
        
        return anchors
    }
    
    func frame(in view: UIView) -> CGRect {
        return superview?.convert(frame, to: view) ?? convert(frame, to: view)
    }
    
    func translateAndFade(as direction: TransitionalDirection,
                        animationStyle: UIViewAnimationStyle,
                        percentageEndPoint: TimeInterval = 1,
                        translate: CGPoint) {
        
        layer.removeAllAnimations()
        
        let duration = animationStyle.duration *
            (direction == .transitionIn ? 1 - percentageEndPoint : percentageEndPoint)
        let delay = animationStyle.duration - duration
        
        var mutatedAnimationStyle = animationStyle
        mutatedAnimationStyle.duration = duration
        
        if direction == .transitionIn {
            transform.tx = translate.x
            transform.ty = translate.y
            alpha = 0
            UIView.animate(withStyle: mutatedAnimationStyle,
                           delay: delay,
                           animations: {
                self.transform.tx = 0
                self.transform.ty = 0
                self.alpha = 1
            })
        }
        
        if direction == .transitionOut {
            transform.tx = 0
            transform.ty = 0
            alpha = 1
            UIView.animate(withStyle: mutatedAnimationStyle,
                           animations: {
                self.transform.tx = translate.x
                self.transform.ty = translate.y
                self.alpha = 0
            })
        }
    }
    
    func transformAnimation(as direction: TransitionalDirection,
                          animationStyle: UIViewAnimationStyle,
                          percentageEndPoint: TimeInterval = 1,
                          transform: CGAffineTransform) {
        
        let duration = animationStyle.duration *
            (direction == .transitionIn ? 1 - percentageEndPoint : percentageEndPoint)
        let delay = animationStyle.duration - duration
        
        var mutatedAnimationStyle = animationStyle
        mutatedAnimationStyle.duration = duration
        
        if direction == .transitionIn {
            self.transform = transform
            UIView.animate(withStyle: mutatedAnimationStyle,
                           delay: delay,
                           animations: {
                            self.transform = .identity
            })
        }
        
        if direction == .transitionOut {
            self.transform = .identity
            UIView.animate(withStyle: mutatedAnimationStyle,
                           animations: {
                            self.transform = transform
            })
        }
    }
    
    func fadeAnimation(as direction: TransitionalDirection,
                          animationStyle: UIViewAnimationStyle,
                          percentageEndPoint: TimeInterval = 1) {
        
        let duration = animationStyle.duration *
            (direction == .transitionIn ? 1 - percentageEndPoint : percentageEndPoint)
        let delay = animationStyle.duration - duration
        
        var mutatedAnimationStyle = animationStyle
        mutatedAnimationStyle.duration = duration
        
        if direction == .transitionIn {
            alpha = 0
            UIView.animate(withStyle: mutatedAnimationStyle,
                           delay: delay,
                           animations: {
                            self.alpha = 1
            })
        }
        
        if direction == .transitionOut {
            alpha = 1
            UIView.animate(withStyle: mutatedAnimationStyle,
                           animations: {
                            self.alpha = 0
            })
        }
    }
    
    enum TransitionalDirection {
        case transitionIn
        case transitionOut
    }
}
