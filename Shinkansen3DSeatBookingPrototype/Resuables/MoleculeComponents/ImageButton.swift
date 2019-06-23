//
//  ImageButton.swift
//  Shinkansen 3D Seat Booking Prototype
//
//  Created by Virakri Jinangkul on 6/1/19.
//  Copyright © 2019 Virakri Jinangkul. All rights reserved.
//

import UIKit

class ImageButton: UIButton {
    
    override var isHighlighted: Bool {
        didSet {
            alpha = isHighlighted ? CGFloat(DesignSystem.opacity.highlighted) : 1
        }
    }
    
    init(image: UIImage?) {
        super.init(frame: .zero)
        setImage(image?.withRenderingMode(.alwaysTemplate), for: .normal)
        setupTheme()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setupTheme() {
        tintColor = currentColorTheme.componentColor.primaryText
        tintAdjustmentMode = .normal
    }
}
