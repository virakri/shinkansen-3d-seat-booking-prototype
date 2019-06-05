//
//  BookingSummaryViewController.swift
//  Shinkansen Tickets Booking Prototype
//
//  Created by Virakri Jinangkul on 5/14/19.
//  Copyright © 2019 Virakri Jinangkul. All rights reserved.
//

import UIKit

class BookingConfirmationViewController: BookingViewController {
    
    var mainCardView: CardControl!
    
    var dateLabelContainerView: UIView!
    
    var dateLabel: Label!
    
    override func setupView() {
        super.setupView()
        mainViewType = .view
        
        dateLabelSetView.isHidden = true
        topBarStackView.addArrangedSubview(UIView())
        
        dateLabel = Label()
        dateLabelContainerView = UIView(containingView: dateLabel,
                                        withConstaintEquals: [.centerHorizontal, .top, .bottom],
                                        insetsConstant: .init(top: 4, leading: 0, bottom: 0, trailing: 0))
        
        mainStackView.removeArrangedSubview(topBarStackView)
        mainStackView.removeArrangedSubview(mainContentView)
        mainStackView.insertArrangedSubview(mainContentView, at: 0)
        mainStackView.insertArrangedSubview(dateLabelContainerView, at: 1)
        mainStackView.addArrangedSubview(UIView())
        
        view.addSubview(topBarStackView, withConstaintEquals: [.topSafeArea, .leadingMargin, .trailingMargin])
//        mainCardView.
        
        mainCardView = CardControl(type: .large)
        mainContentView.addSubview(mainCardView, withConstaintEquals: .edges)
        mainContentView.widthAnchor.constraint(equalTo: mainContentView.heightAnchor, multiplier: DesignSystem.isNarrowScreen ? 1.25 : 1).isActive = true
        mainCardView.isUserInteractionEnabled = false
        
        setHeaderInformationValue(headerInformation)
    }
    
    override func setupTheme() {
        super.setupTheme()
        dateLabel.textStyle = textStyle.headline()
        dateLabel.textColor = currentColorTheme.componentColor.primaryText
    }
    
    override func setupInteraction() {
        super.setupInteraction()
        
        mainCallToActionButton.addTarget(self,
                                         action: #selector(mainCallToActionButtonDidTouch(_:)),
                                         for: .touchUpInside)
        
        backButton.addTarget(self,
                             action: #selector(backButtonDidTouch(_:)),
                             for: .touchUpInside)
    }
    
    override func setHeaderInformationValue(_ headerInformation: BookingViewController.HeaderInformation?) {
        super.setHeaderInformationValue(headerInformation)
        guard let headerInformation = headerInformation,
            let dateLabel = dateLabel else { return }
        dateLabel.text = "\(headerInformation.dayOfWeek), \(headerInformation.date)"
    }
    
    @objc func mainCallToActionButtonDidTouch(_ sender: Button) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func backButtonDidTouch(_ sender: Button) {
        navigationController?.popViewController(animated: true)
    }
}
