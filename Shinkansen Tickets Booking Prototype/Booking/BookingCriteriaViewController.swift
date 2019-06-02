//
//  BookingCriteriaViewController.swift
//  Shinkansen Tickets Booking Prototype
//
//  Created by Virakri Jinangkul on 5/14/19.
//  Copyright © 2019 Virakri Jinangkul. All rights reserved.
//

import UIKit

class BookingCriteriaViewController: BookingViewController {
    
    //
    var stackView: UIStackView!
    
    var headerStackView: UIStackView!
    
    var inputStackView: UIStackView!
    
    var headlineLabel: Label!
    
    var logoImageView: UIImage!
    
    var fromStationContainerView: HeadlineWithContainerView!
    
    //    var
    
    var destinationStationContainerView: HeadlineWithContainerView!
    
//    var
    
    var dateSegmentedContainerView: HeadlineWithContainerView!
    
    var timeSegmentedContainerView: HeadlineWithContainerView!
    
    var dateSegmentedControl : SegmentedCardControl!
    
    var timeSegmentedControl: SegmentedCardControl!
    
//    var
    
    override func setupView() {
        super.setupView()
        mainStackView.isHidden = true
        
        
        
        
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
    
    @objc func mainCallToActionButtonDidTouch(_ sender: Button) {
        let trainSelectionViewController = TrainSelectionViewController()
        trainSelectionViewController.headerInformation =
            HeaderInformation(dayOfWeek: "Monday", date: "June 3, 2019",
                              fromStation: "Osaka", toStation: "Tokyo")
        navigationController?.pushViewController(trainSelectionViewController, animated: true)
    }
    
    @objc func backButtonDidTouch(_ sender: Button) {
        
    }
}
