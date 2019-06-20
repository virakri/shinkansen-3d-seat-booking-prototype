//
//  BookingSummaryViewController.swift
//  Shinkansen Tickets Booking Prototype
//
//  Created by Virakri Jinangkul on 5/14/19.
//  Copyright © 2019 Virakri Jinangkul. All rights reserved.
//

import UIKit

class BookingConfirmationViewController: BookingViewController {
    
    var summaryPreviewView: SummaryPreviewView!
    
    var mainCardView: CardControl!
    
    var dateLabelContainerView: UIView!
    
    var selectedReservableEntity: ReservableEntity?
    
//    var dateLabel: Label!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupStaticContent()
    }
    
    override func setupView() {
        super.setupView()
        mainViewType = .view
        
        dateLabelContainerView = UIView(containingView: dateLabel,
                                        withConstaintEquals: [.centerHorizontal, .top, .bottom],
                                        insetsConstant: .init(top: 4, leading: 0, bottom: 0, trailing: 0))
        
        let placeholderView = UIView()
        
        mainStackView.removeArrangedSubview(datePlaceholderLabel)
        mainStackView.removeArrangedSubview(mainContentView)
        mainStackView.insertArrangedSubview(mainContentView, at: 0)
        mainStackView.insertArrangedSubview(dateLabelContainerView, at: 1)
        mainStackView.addArrangedSubview(UIView())
        mainStackView.addArrangedSubview(placeholderView)
        
        view.addSubview(datePlaceholderLabel, withConstaintEquals: [.topSafeArea, .centerHorizontal])
        view.addConstraints(toView: datePlaceholderLabel, withConstaintGreaterThanOrEquals: [.leadingMargin, .trailingMargin])
        
        let datePlaceholderLabelWidthConstraint = datePlaceholderLabel.widthAnchor.constraint(equalToConstant: DesignSystem.layout.maximumWidth)
        datePlaceholderLabelWidthConstraint.priority = .defaultHigh
        datePlaceholderLabelWidthConstraint.isActive = true
        
        mainCardView = CardControl(type: .large)
        mainContentView.addSubview(mainCardView,
                                   withConstaintEquals: .edges,
                                   insetsConstant: .init(top: -mainCardView.layer.cornerRadius))
        mainContentView.heightAnchor.constraint(lessThanOrEqualTo:  mainContentView.widthAnchor, multiplier: 1).isActive = true
        
        summaryPreviewView = SummaryPreviewView()
        summaryPreviewView.selectedReservableEntity = selectedReservableEntity
        
        // Setup Main Card View
        mainCardView.isUserInteractionEnabled = false
        mainCardView.contentView
            .addSubview(summaryPreviewView,
                        withConstaintEquals: .edges)
        
        placeholderView.translatesAutoresizingMaskIntoConstraints = false
        placeholderView.topAnchor.constraint(equalTo: mainCallToActionButton.topAnchor).isActive = true
        
        setHeaderInformationValue(headerInformation)
        view.bringSubviewToFront(backButton)
    }
    
    override func setupTheme() {
        super.setupTheme()
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
    }
    
    private func setupStaticContent() {
        mainCallToActionButton.setTitle("Purchase this Ticket—\(headerInformation?.price ?? "")")
    }
    
    @objc func mainCallToActionButtonDidTouch(_ sender: Button) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func backButtonDidTouch(_ sender: Button) {
        navigationController?.popViewController(animated: true)
    }
}
