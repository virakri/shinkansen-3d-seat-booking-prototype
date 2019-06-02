//
//  HeadlineWithContainerView.swift
//  Shinkansen Tickets Booking Prototype
//
//  Created by Virakri Jinangkul on 6/2/19.
//  Copyright © 2019 Virakri Jinangkul. All rights reserved.
//

import UIKit
import Kumi

class HeadlineWithContainerView: UIStackView {
    
    var titleLabel: Label
    
    var view: UIView
    
    init(title: String, withView view: UIView) {
        titleLabel = Label()
        self.view = view
        super.init(frame: .zero)
        
        //
        titleLabel.text = title
        
        setupView()
        setupTheme()
        
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        axis = .vertical
        spacing = 4
        
        addArrangedSubview(titleLabel)
        addArrangedSubview(view)
    }
    
    func setupTheme() {
        titleLabel.textStyle = textStyle.footnote()
        titleLabel.textColor = currentColorTheme.componentColor.secondaryText
    }
}
