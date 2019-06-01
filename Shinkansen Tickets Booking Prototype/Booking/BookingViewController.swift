//
//  BookingViewController.swift
//  Shinkansen Tickets Booking Prototype
//
//  Created by Virakri Jinangkul on 6/1/19.
//  Copyright © 2019 Virakri Jinangkul. All rights reserved.
//

import UIKit

class BookingViewController: ViewController {
    
    enum MainViewType {
        case tableView
        case view
    }
    
    var mainViewType: MainViewType = .tableView {
        didSet {
            switch mainViewType {
            case .tableView:
                mainTableView.isHidden = false
                mainContentView.isHidden = true
            case .view:
                mainTableView.isHidden = true
                mainContentView.isHidden = false
            }
        }
    }
    
    var mainCallToActionButton: Button!
    
    var mainStackView: UIStackView!
    
    var headerWithTopBarStackView: UIStackView!
    
    var backButton: ImageButton! // Temporary until the button animation is done.
    
    var dateLabelSetView: DateLabelSetView!
    
    var headerRouteInformationView: HeaderRouteInformationView!
    
    var mainContentView: UIView!
    
    var mainTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupView() {
        super.setupView()
        
        // MARK: Header
        backButton = ImageButton(image: #imageLiteral(resourceName: "symbol-close-button"))
        dateLabelSetView = DateLabelSetView(dayOfWeek: "Lorem", date: "Lorem Ipsum")
        let topBarStackView = UIStackView([backButton, dateLabelSetView],
                                          axis: .horizontal,
                                          distribution: .equalSpacing,
                                          alignment: .center)
        
        headerRouteInformationView = HeaderRouteInformationView(fromStation: "osaka", fromTime: "7:12", toStation: "Tokyo", toTime: "12:34", trainNumber: "Hayabusa 12", trainName: "E5 Series", carNumber: "Car 3", className: "Ordinary", seatNumber: "12C", price: "$12,000")
        
        headerWithTopBarStackView = UIStackView([topBarStackView, headerRouteInformationView],
                                                axis: .vertical,
                                                distribution: .fill,
                                                alignment: .fill,
                                                spacing: 20)
        
        let headerWithTopBarContainerView = UIView(containingView: headerWithTopBarStackView, withConstaintEquals: [.topSafeArea, .leadingMargin, .trailingMargin, .bottom])
        
        headerWithTopBarContainerView.preservesSuperviewLayoutMargins = true
        
        mainContentView = UIView()
        mainContentView.preservesSuperviewLayoutMargins = true
        mainContentView.backgroundColor = .red
        mainContentView.isHidden = true
        
        mainTableView = UITableView(frame: .zero, style: .plain)
        mainTableView.preservesSuperviewLayoutMargins = true
        mainTableView.backgroundColor = .clear
        mainTableView.separatorStyle = .none
        mainTableView.contentInset.top = 12
        mainTableView.contentOffset.y = -12
        
        mainStackView = UIStackView([headerWithTopBarContainerView, mainContentView, mainTableView],
                                    axis: .vertical,
                                    distribution: .fill,
                                    alignment: .fill, spacing: 20)
        mainStackView.preservesSuperviewLayoutMargins = true
        
        view.addSubview(mainStackView, withConstaintEquals: .edges)
        
        // MARK: Setup Button
        mainCallToActionButton = Button(type: .contained)
        view.addSubview(mainCallToActionButton, withConstaintEquals: [.leadingMargin, .trailingMargin])
        view.constraintBottomSafeArea(to: mainCallToActionButton, withMinimumConstant: 16)
        
    }
    
    override func setupTheme() {
        super.setupTheme()
        
        mainCallToActionButton.setupTheme()
        backButton.setupTheme()
        dateLabelSetView.setupTheme()
        headerRouteInformationView.setupTheme()
        mainTableView.setupTheme()
        
    }
    
    override func setupInteraction() {
        super.setupInteraction()
    }
    
}
