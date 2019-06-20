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
        contentView.directionalLayoutMargins = .init(vertical: 12, horizontal: 12)
    }
    
    public override func setupTheme() {
        super.setupTheme()
        label.textStyle = textStyle.caption1()
        label.textColor = currentColorTheme.componentColor.secondaryText
        
    }
    
    public func setupContent(message: String, animated: Bool = true) {
        label.text = message
        isHidden = false
        if animated {
            alpha = 0
            transform.ty = bounds.height
            UIView.animate(withStyle: .normalAnimationStyle,
                           animations: {
                            self.alpha = 1
                            self.transform.ty = 0
            })
        }
    }
}
