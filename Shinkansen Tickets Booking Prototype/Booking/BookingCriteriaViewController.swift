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
    
    var logoImageView: UIImageView!
    
    var horizontalStationStackView: UIStackView!
    
    var fromStationContainerView: HeadlineWithContainerView!
    
    var fromStationCardControl: StationCardControl!
    
    var destinationStationContainerView: HeadlineWithContainerView!
    
    var destinationStationCardControl: StationCardControl!
    
    var arrowImageView: UIImageView!
    
    var dateSegmentedContainerView: HeadlineWithContainerView!
    
    var timeSegmentedContainerView: HeadlineWithContainerView!
    
    var dateSegmentedControl : SegmentedCardControl!
    
    var timeSegmentedControl: SegmentedCardControl!
    
    private var logoImageAlignmentConstraint: NSLayoutConstraint!
    
//    var
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupStaticContent()
    }
    
    override func setupView() {
        super.setupView()
        dateLabelSetView.isHidden = true
        headerRouteInformationView.isHidden = true
        mainStackView.isHidden = true
        backButton.isHidden = true
        
        //
        
        headlineLabel = Label()
        headlineLabel.numberOfLines = 0
        
        logoImageView = UIImageView()
        logoImageView.setContentHuggingPriority(.required, for: .horizontal)
        let logoImageContainerView = UIView(containingView: logoImageView, withConstaintEquals: [.leading, .trailing])
        
        headerStackView = UIStackView([headlineLabel, logoImageContainerView],
                                      axis: .horizontal,
                                      distribution: .fill,
                                      alignment: .top)
        
        logoImageAlignmentConstraint = logoImageView.topAnchor.constraint(equalTo: headlineLabel.firstBaselineAnchor)
        logoImageAlignmentConstraint.isActive = true
        
        fromStationCardControl = StationCardControl()
        
        destinationStationCardControl = StationCardControl()
        
        fromStationContainerView = HeadlineWithContainerView(containingView: fromStationCardControl)
        
        destinationStationContainerView = HeadlineWithContainerView(containingView: destinationStationCardControl)
        
        arrowImageView = UIImageView()
        
        let arrowImageContainerView = UIView(containingView: arrowImageView, withConstaintEquals: [.leading, .trailing])
        
        horizontalStationStackView = UIStackView([fromStationContainerView,
                                        arrowImageContainerView,
                                        destinationStationContainerView],
                                       axis: .horizontal,
                                       distribution: .fill,
                                       alignment: .fill,
                                       spacing: 12)
        
        arrowImageView.centerYAnchor.constraint(equalTo: fromStationContainerView.view.centerYAnchor).isActive = true
        
//        arrowImageView.setContentCompressionResistancePriority(.required, for: .horizontal)
//        arrowImageView.setContentCompressionResistancePriority(.required, for: .vertical)
        
        fromStationContainerView.widthAnchor.constraint(equalTo: destinationStationContainerView.widthAnchor).isActive = true
        
        dateSegmentedControl = SegmentedCardControl()
        dateSegmentedContainerView = HeadlineWithContainerView(containingView: dateSegmentedControl)
        
        timeSegmentedControl = SegmentedCardControl()
        timeSegmentedContainerView = HeadlineWithContainerView(containingView: timeSegmentedControl)
        
        inputStackView = UIStackView([horizontalStationStackView,
                                      dateSegmentedContainerView,
                                      timeSegmentedContainerView],
                                     axis: .vertical,
                                     distribution: .fill,
                                     alignment: .fill,
                                     spacing: 24)
        
        stackView = UIStackView([headerStackView,
                                 inputStackView],
                                axis: .vertical,
                                distribution: .fill,
                                alignment: .fill, spacing: DesignSystem.isNarrowScreen ? 24 : 48)
        
        view.addSubview(stackView,
                        withConstaintEquals: [.topSafeArea, .centerHorizontal],
                        insetsConstant: .init(top: 24))
        view.addConstraints(toView: stackView, withConstaintGreaterThanOrEquals: [.leadingMargin, .trailingMargin])
        
        let stackViewWidthConstraint = stackView.widthAnchor.constraint(equalToConstant: DesignSystem.layout.maximumWidth)
        stackViewWidthConstraint.priority = .init(999)
        stackViewWidthConstraint.isActive = true
    }
    
    override func setupTheme() {
        super.setupTheme()
        
        headlineLabel.textStyle = textStyle.largeTitle()
        headlineLabel.textColor = currentColorTheme.componentColor.callToAction
        logoImageAlignmentConstraint.constant = -textStyle.largeTitle().font.capHeight
        
        fromStationContainerView.setupTheme()
        destinationStationContainerView.setupTheme()
        dateSegmentedContainerView.setupTheme()
        timeSegmentedContainerView.setupTheme()
        
        fromStationCardControl.setupTheme()
        destinationStationCardControl.setupTheme()
        dateSegmentedControl.setupTheme()
        timeSegmentedControl.setupTheme()
        
        
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
    
    func setupStaticContent() {
        headlineLabel.text = "Reserve \nShinkansen \nTickets"
        
        logoImageView.image = #imageLiteral(resourceName: "Logo JR East")
        
        arrowImageView.image = #imageLiteral(resourceName: "Icon Arrow Right")
        
        fromStationContainerView.setTitle(title: "From")
        
        destinationStationContainerView.setTitle(title: "Destination")
        
        fromStationCardControl.setupValue(stationNameJP: "東京", stationName: "Tokyo")
        destinationStationCardControl.setupValue(stationNameJP: "大宮", stationName: "Ōmiya")
        
        dateSegmentedContainerView.setTitle(title: "Date")
        dateSegmentedControl.items = [(title: "Today", subtitle: "Jun 3, 2019"),
                                      (title: "Tomorrow", subtitle: "Jun 4, 2019"),
                                      (title: "Pick a Date", subtitle: " ")]
        dateSegmentedControl.selectedIndex = 0
        
        timeSegmentedContainerView.setTitle(title: "Time")
        timeSegmentedControl.items = [(title: "Morning", subtitle: "6AM - 12PM"),
                                      (title: "Afternoon", subtitle: "12PM - 6PM"),
                                      (title: "Evening", subtitle: "6PM - 12AM")]
        
        timeSegmentedControl.selectedIndex = 0
        
        mainCallToActionButton.setTitle("Search for Tickets")
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
