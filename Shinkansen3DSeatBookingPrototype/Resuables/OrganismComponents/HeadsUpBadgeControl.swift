//
//  HeadsUpBadgeControl.swift
//  Shinkansen 3D Seat Booking Prototype
//
//  Created by Virakri Jinangkul on 6/19/19.
//  Copyright © 2019 Virakri Jinangkul. All rights reserved.
//

import UIKit
import Kumi

class HeadsUpBadgeControl: CardControl {
    
    private var label: Label
    
    private var initialYOffset: CGFloat = -CGFloat(32).systemSizeMuliplier() * 1.5
    
     init() {
        label = Label()
        super.init(type: .regularAlternative)
        setupView()
        setupTheme()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        contentView.addSubview(label, withConstaintEquals: .marginEdges)
        contentView.directionalLayoutMargins = .init(vertical: 12, horizontal: 16)
    }
    
    public override func setupTheme() {
        super.setupTheme()
        label.textStyle = textStyle.caption1()
        label.textColor = currentColorTheme.componentColor.secondaryText
        
    }
    
    public func setupContent(message: String,
                             animated: Bool = true,
                             delay: TimeInterval = 0,
                             completion: ((Bool)->())? = nil) {
        label.text = message
        isHidden = false
        if animated {
            alpha = 0
            transform.ty = initialYOffset
            UIView.animate(withStyle: .halfTransitionAnimationStyle,
                           delay: delay,
                           animations: {
                            self.alpha = 1
                            self.transform = .identity
            },
                           completion: completion)
        }
    }
    
    public func dismiss(animated: Bool = true,
                        delay: TimeInterval = 0,
                        removeWhenComplete: Bool = true,
                        completion: ((Bool)->())? = nil) {
        isHidden = false
        if animated {
            alpha = 1
            transform = .identity
            UIView
                .animate(withStyle: .transitionAnimationStyle,
                         delay: delay,
                         animations: {
                            self.alpha = 0
                            self.transform.ty = self.initialYOffset
                }, completion: {
                    finished in
                    if removeWhenComplete { self.removeFromSuperview() }
                    if let completion = completion {
                        completion(finished)
                    }
                })
        } else {
            if removeWhenComplete { self.removeFromSuperview() }
            if let completion = completion {
                completion(true)
            }
        }
    }
}
