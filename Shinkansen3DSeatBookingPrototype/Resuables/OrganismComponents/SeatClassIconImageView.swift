//
//  SeatClassIconImageView.swift
//  Shinkansen 3D Seat Booking Prototype
//
//  Created by Virakri Jinangkul on 6/1/19.
//  Copyright © 2019 Virakri Jinangkul. All rights reserved.
//

import UIKit


extension SeatClassType {
    func image() -> UIImage {
        switch self {
        case .granClass:
            return #imageLiteral(resourceName: "gran")
        case .green:
            return #imageLiteral(resourceName: "green")
        case .ordinary:
            return #imageLiteral(resourceName: "ordinary")
        }
    }
    
    func iconImage() -> UIImage {
        switch self {
        case .granClass:
            return #imageLiteral(resourceName: "Icon Gran").withRenderingMode(.alwaysTemplate)
        case .green:
            return #imageLiteral(resourceName: "Icon Green Car").withRenderingMode(.alwaysTemplate)
        case .ordinary:
            return #imageLiteral(resourceName: "Icon Ordinary").withRenderingMode(.alwaysTemplate)
        }
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


class SeatClassIconImageView: UIImageView {
    
    private(set) var seatClass: SeatClassType {
        didSet {
            image = seatClass.iconImage()
        }
    }
    
    private(set) var iconSize: IconSize
    
    var isAvailable: Bool = true {
        didSet {
            setupTheme()
        }
    }
    
    init(seatClass: SeatClassType,
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
        image = seatClass.iconImage()
    }
    
    public func setupTheme() {
        tintColor = isAvailable ? seatClass.color() : currentColorTheme.componentColor.callToActionDisabled
        alpha = isAvailable ? 1 : DesignSystem.alpha.disabled
    }
    
    public func setSeatClass(to seatClass: SeatClassType) {
        self.seatClass = seatClass
    }
}
