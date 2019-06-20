//
//  HeadsUpBadgeControl.swift
//  Shinkansen Tickets Booking Prototype
//
//  Created by Virakri Jinangkul on 6/19/19.
//  Copyright © 2019 Virakri Jinangkul. All rights reserved.
//

import UIKit
import Kumi

class HeadsUpBadgeControl: CardControl {
    
    private var label: Label
    
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
            transform.ty = -bounds.height * 1.5
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
                            self.transform.ty = -self.bounds.height * 1.5
                }, completion: {
                    finished in
                    self.isHidden = true
                    
                    if let completion = completion {
                        completion(finished)
                    }
                })
        }
    }
}
