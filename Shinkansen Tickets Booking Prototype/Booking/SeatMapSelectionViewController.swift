//
//  SeatMapSelectionViewController.swift
//  Shinkansen Tickets Booking Prototype
//
//  Created by Virakri Jinangkul on 5/14/19.
//  Copyright © 2019 Virakri Jinangkul. All rights reserved.
//

import UIKit

class SeatMapSelectionViewController: BookingViewController {
    
    var mainCardView: CardControl!
    
    var selectedSeatID: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupStaticContent()
    }
    
    override func setupView() {
        super.setupView()
        mainViewType = .view
        
        mainCardView = CardControl(type: .large)
        mainContentView.addSubview(mainCardView,
                                   withConstaintEquals: .edges,
                                   insetsConstant: .init(bottom: -mainCardView.layer.cornerRadius))
        mainCardView.isUserInteractionEnabled = false
        
        let dummySeatMapView = UIView()
        dummySeatMapView.backgroundColor = .red
        dummySeatMapView.widthAnchor.constraint(equalToConstant: 240).isActive = true
        dummySeatMapView.heightAnchor.constraint(equalToConstant: 240).isActive = true
        mainCardView.contentView.addSubview(dummySeatMapView, withConstaintEquals: .center)
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
    
    private func setupStaticContent() {
        mainCallToActionButton.setTitle("Pick a Seat")
    }
    
    @objc func mainCallToActionButtonDidTouch(_ sender: Button) {
        let bookingConfirmationViewController = BookingConfirmationViewController()
        bookingConfirmationViewController.headerInformation = headerInformation
        bookingConfirmationViewController.headerInformation?.seatNumber = "5A"
        navigationController?.pushViewController(bookingConfirmationViewController, animated: true)
    }
    
    @objc func backButtonDidTouch(_ sender: Button) {
        navigationController?.popViewController(animated: true)
    }
}
