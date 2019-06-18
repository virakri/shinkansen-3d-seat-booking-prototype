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
    
    var dateSegmentedControl : SegmentedControl!
    
    var timeSegmentedControl: SegmentedControl!
    
    private var logoImageAlignmentConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupStaticContent()
    }
    
    override func setupView() {
        super.setupView()
        dateLabel.isHidden = true
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
        
        fromStationContainerView.widthAnchor.constraint(equalTo: destinationStationContainerView.widthAnchor).isActive = true
        
        dateSegmentedControl = SegmentedControl()
        dateSegmentedControl.addTarget(self, action: #selector(reloadTimeSegemtnedControl), for: .valueChanged)
        dateSegmentedContainerView = HeadlineWithContainerView(containingView: dateSegmentedControl)
        
        timeSegmentedControl = SegmentedControl()
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
        
        let today = Date()
        let tomorrow = today.addingTimeInterval(60 * 60 * 24)
        let formatter = FullDateFormatter()
        dateSegmentedControl.items = [(title: "Today", subtitle: formatter.string(from: today), true),
                                      (title: "Tomorrow", subtitle: formatter.string(from: tomorrow), true),
                                      (title: "Pick a Date", subtitle: " ", true)]
        
        // Specify date components
//        var dateComponents = DateComponents()
//        dateComponents.timeZone = TimeZone(abbreviation: "JST") // Japan Standard Time
//        dateComponents.hour = 8
//        dateComponents.minute = 0
//        let someDateTime = Calendar.current.date(from: dateComponents)
        
        timeSegmentedContainerView.setTitle(title: "Time")
        
        reloadTimeSegemtnedControl()
        
        mainCallToActionButton.setTitle("Search for Tickets")
    }
    
    @objc private func reloadTimeSegemtnedControl() {
        
        let timeInterval: TimeInterval
        switch dateSegmentedControl.selectedIndex {
        case 0:
            timeInterval = 0
        case 1:
            timeInterval = 60 * 60 * 24
        default:
            timeInterval = 60 * 60 * 24 * 2
        }
        
        let morning = (Date(byHourOf: 6)...Date(byHourOf: 12)).addingTimeInterval(timeInterval)
        let afternoon = (Date(byHourOf: 12)...Date(byHourOf: 18)).addingTimeInterval(timeInterval)
        let evening = (Date(byHourOf: 18)...Date(byHourOf: 24)).addingTimeInterval(timeInterval)
        let now = Date()
        
        timeSegmentedControl.items = [(title: "Morning",
                                       subtitle: morning.toString(),
                                       isEnabled: now < morning.upperBound),
                                      (title: "Afternoon",
                                       subtitle: afternoon.toString(),
                                       isEnabled: now < afternoon.upperBound),
                                      (title: "Evening",
                                       subtitle: evening.toString(),
                                       isEnabled: now < evening.upperBound)]
    }
    
    @objc func mainCallToActionButtonDidTouch(_ sender: Button) {
        
        
        let dateOffset: TimeInterval
        switch dateSegmentedControl.selectedIndex {
        case 0:
            dateOffset = 0
        case 1:
            dateOffset = 60 * 60 * 24
        default:
            dateOffset = 60 * 60 * 24 * 2
        }
        
        let selectedDate = Date(timeIntervalSinceNow: dateOffset)
        
        let timeOffset: TimeInterval
        switch timeSegmentedControl.selectedIndex {
        case 0:
            timeOffset = 0
        case 1:
            timeOffset = TimeInterval(60 * 60 * 6)
        default:
            timeOffset = TimeInterval(60 * 60 * 12)
        }
        let trainSelectionVC = TrainSelectionViewController()
        
        let formatter = FullDateFormatter()
        let dayOfWeek = Calendar.current.weekdaySymbols[Calendar.current.component(.weekday, from: selectedDate) - 1]
        let date = formatter.string(from: selectedDate)
        let fromStation = "Tokyo"
        let toStation = "Ōmiya"
        
        trainSelectionVC.headerInformation =
            HeaderInformation(dayOfWeek: dayOfWeek,
                              date: date,
                              fromStation: fromStation,
                              toStation: toStation)
        trainSelectionVC.dateOffset = dateOffset
        trainSelectionVC.timeOffset = timeOffset
        navigationController?.pushViewController(trainSelectionVC, animated: true)
    }
    
    @objc func backButtonDidTouch(_ sender: Button) {
        
    }
}

extension ClosedRange where Bound == Date {
    func toString() -> String {
        return "\(lowerBound.timeHour) - \(upperBound.timeHour)"
    }
    
    func addingTimeInterval(_ timeInterval: TimeInterval) -> ClosedRange {
        return lowerBound.addingTimeInterval(timeInterval)...upperBound.addingTimeInterval(timeInterval)
    }
}
