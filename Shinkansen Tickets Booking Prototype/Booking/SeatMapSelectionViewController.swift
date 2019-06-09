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
    
    var seatClass: SeatClass?
    
    var seatClassEntity: SeatClassEntity?
    
    private var isTransitionPerforming: Bool = true
    
    private var selectedEntity: ReservableEntity? {
        didSet {
            headerInformation?.carNumber = selectedEntity?.carNumber
            mainCallToActionButton.isEnabled = selectedEntity != nil
            mainCallToActionButton.setTitle("Pick a Seat—\(selectedEntity?.name ?? "*")")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupStaticContent()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        isTransitionPerforming = false
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
        mainCallToActionButton.isEnabled = false
        setupScene()
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
    
    private func setupScene() {
        print(seatClassEntity?.reservableEntities.count ?? 0)
        
        seatMapSceneView.setupContent(seatClassEntity: seatClassEntity)
    }
    
    func verticalRubberBandEffect(byVerticalContentOffset contentOffsetY: CGFloat)  {
        guard contentOffsetY < 0 else {
            mainCardView.transform.ty = 0
            headerRouteInformationView.verticalRubberBandEffect(byVerticalContentOffset: 0)
            backButton.shapeView.transform.tx = 0
            return
        }
        mainCardView.transform.ty = -contentOffsetY
        
        headerRouteInformationView.verticalRubberBandEffect(byVerticalContentOffset: contentOffsetY)
        let translateX = contentOffsetY <= 0 ? -contentOffsetY / 6 : 0
        backButton.shapeView.transform.tx = translateX
    }
    
    @objc func mainCallToActionButtonDidTouch(_ sender: Button) {
        
        guard let selectedEntity = selectedEntity else {
            return
        }
        isTransitionPerforming = true
        
        let bookingConfirmationViewController = BookingConfirmationViewController()
        bookingConfirmationViewController.headerInformation = headerInformation
        bookingConfirmationViewController.headerInformation?.seatNumber = selectedEntity.name
        bookingConfirmationViewController.headerInformation?.price = seatClass?.price.yen
        navigationController?.pushViewController(bookingConfirmationViewController, animated: true)
    }
    
    @objc func backButtonDidTouch(_ sender: Button) {
        isTransitionPerforming = true
        
        navigationController?.popViewController(animated: true)
    }
}

extension SeatMapSelectionViewController: SeatMapSceneViewDelegate {
    
    func sceneViewDidPanFurtherUpperBoundLimit(by offset: CGPoint) {
        
        if !isPopPerforming {
            
            isPopPerforming = offset.y < -72
            
            // Perform interaction
            if !isTransitionPerforming {
                DispatchQueue.main.async {
                    self.verticalRubberBandEffect(byVerticalContentOffset: offset.y)
                }
            }
        }
    }
    
    func sceneView(sceneView: SeatMapSceneView, didSelected reservableEntity: ReservableEntity) {
        selectedEntity = reservableEntity
    }
}
