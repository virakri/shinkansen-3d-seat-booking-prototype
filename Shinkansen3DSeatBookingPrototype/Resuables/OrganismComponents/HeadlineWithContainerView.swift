//
//  HeadlineWithContainerView.swift
//  Shinkansen 3D Seat Booking Prototype
//
//  Created by Virakri Jinangkul on 6/2/19.
//  Copyright © 2019 Virakri Jinangkul. All rights reserved.
//

import UIKit
import Kumi

class HeadlineWithContainerView: UIStackView {
    
    var titleLabel: Label
    
    var view: UIView
    
    convenience init(title: String, containingView view: UIView) {
        self.init(containingView: view)
        setTitle(title: title)
    }
    
    init(containingView view: UIView) {
        titleLabel = Label()
        self.view = view
        super.init(frame: .zero)
        
        setupView()
        setupTheme()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        axis = .vertical
        spacing = 10
        
        addArrangedSubview(titleLabel)
        addArrangedSubview(view)
    }
    
    func setupTheme() {
        titleLabel.textStyle = textStyle.footnote()
        titleLabel.textColor = currentColorTheme.componentColor.secondaryText
    }
    
    func setTitle(title: String) {
        titleLabel.text = title
    }
}
