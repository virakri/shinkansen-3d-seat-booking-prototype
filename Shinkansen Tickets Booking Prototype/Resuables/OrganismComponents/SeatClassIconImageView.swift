//
//  SeatClassIconImageView.swift
//  Shinkansen Tickets Booking Prototype
//
//  Created by Virakri Jinangkul on 6/1/19.
//  Copyright © 2019 Virakri Jinangkul. All rights reserved.
//

import UIKit
class SeatClassIconImageView: UIImageView {
    
    enum SeatClass {
        case granClass
        case green
        case ordinary
        
        func image() -> UIImage {
            return #imageLiteral(resourceName: "symbol-close-button").withRenderingMode(.alwaysTemplate)
        }
        
        func color() -> UIColor {
            switch self {
            case .granClass:
                return currentColorTheme.seatClassColor.granClass
            case .green:
                return currentColorTheme.seatClassColor.green
            case .ordinary:
                return currentColorTheme.seatClassColor.ordinary
            }
        }
    }
    
    enum IconSize {
        case regular
        case small
        
        func width() -> CGFloat {
            switch self {
            case .regular:
                return 24
            case .small:
                return CGFloat(16).systemSizeMuliplier().clamped(to: 12...24)
            }
        }
    }
    
    private(set) var seatClass: SeatClass {
        didSet {
            image = seatClass.image()
        }
    }
    
    private(set) var iconSize: IconSize
    
    var isAvailable: Bool = true {
        didSet {
            setupTheme()
        }
    }
    
    init(seatClass: SeatClass,
         iconSize: IconSize) {
        self.seatClass = seatClass
        self.iconSize = iconSize
        super.init(frame: .zero)
        setupView()
        setupTheme()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalTo: widthAnchor).isActive = true
        widthAnchor.constraint(equalToConstant: iconSize.width()).isActive = true
        contentMode = .scaleAspectFit
        image = seatClass.image()
    }
    
    public func setupTheme() {
        tintColor = isAvailable ? seatClass.color() : currentColorTheme.componentColor.callToActionDisabled
        alpha = isAvailable ? 1 : DesignSystem.alpha.disabled
    }
    
    public func setSeatClass(to seatClass: SeatClass) {
        self.seatClass = seatClass
    }
}
