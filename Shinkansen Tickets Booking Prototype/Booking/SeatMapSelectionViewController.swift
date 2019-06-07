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
    
    var seatMapSceneView: SeatMapSceneView!
    
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
        
        seatMapSceneView = SeatMapSceneView()
        seatMapSceneView.seatMapDelegate = self
        mainCardView.contentView.addSubview(seatMapSceneView,
                                            withConstaintEquals: .edges)
        
        mainCardView.contentView.isUserInteractionEnabled = true
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
    
    func verticalRubberBandEffect(byVerticalContentOffset contentOffsetY: CGFloat)  {
        guard contentOffsetY < 0 else {
            mainCardView.transform.ty = 0
            return
        }
        mainCardView.transform.ty = -contentOffsetY
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

extension SeatMapSelectionViewController: SeatMapSceneViewDelegate {
    
    func sceneViewDidPanFurtherUpperBoundLimit(by offset: CGPoint) {
        
        DispatchQueue.main.async {
           self.verticalRubberBandEffect(byVerticalContentOffset: offset.y)
            self.headerRouteInformationView.verticalRubberBandEffect(byVerticalContentOffset: offset.y)
            let translateX = offset.y <= 0 ? -offset.y / 6 : 0
            self.backButton.shapeView.transform.tx = translateX
            
        }
        
        if offset.y < -72 {
            isPopPerforming = true
        }
    }
    
}
