//
//  BookingViewController.swift
//  Shinkansen 3D Seat Booking Prototype
//
//  Created by Virakri Jinangkul on 6/1/19.
//  Copyright © 2019 Virakri Jinangkul. All rights reserved.
//

import UIKit

class BookingViewController: ViewController {
    
    struct HeaderInformation {
        var dayOfWeek: String
        var date: String
        var fromStation: String
        var fromTime: String? = nil
        var toStation: String
        var toTime: String? = nil
        var trainNumber: String? = nil
        var trainName: String? = nil
        var carNumber: String? = nil
        var className: String? = nil
        var seatNumber: String? = nil
        var price: String? = nil
        
        init(dayOfWeek: String, date: String, fromStation: String, toStation: String) {
            self.dayOfWeek = dayOfWeek
            self.date = date
            self.fromStation = fromStation
            self.toStation = toStation
            fromTime = nil
            toTime = nil
            trainNumber = nil
            trainName = nil
            carNumber = nil
            className = nil
            seatNumber = nil
            price = nil
        }
    }
    
    enum MainViewType {
        case tableView
        case view
    }
    
    var headerInformation: HeaderInformation? {
        didSet {
            setHeaderInformationValue(headerInformation)
        }
    }
    
    var mainViewType: MainViewType = .tableView {
        didSet {
            switch mainViewType {
            case .tableView:
                mainTableView.isHidden = false
                mainContentView.isHidden = true
                mainCallToActionButton.isHidden = true
            case .view:
                mainTableView.isHidden = true
                mainContentView.isHidden = false
                mainCallToActionButton.isHidden = false
            }
        }
    }
    
    static let feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
    
    var isPopPerforming: Bool = false {
        didSet {
            if oldValue != isPopPerforming && isPopPerforming == true {
                navigationController?.popViewController(animated: true)
                BookingViewController.feedbackGenerator.impactOccurred()
            }
        }
    }
    
    var mainCallToActionButton: Button!
    
    var mainStackView: UIStackView!
    
    var headerWithTopBarStackView: UIStackView!
    
    var backButton: BackButtonControl!
    
    var dateLabel: Label!
    
    var datePlaceholderLabel: Label!
    
    var headerRouteInformationView: HeaderRouteInformationView!
    
    var mainContentView: UIView!
    
    var mainTableView: UITableView!
    
    var interactivePopOverlayView: InteractivePopOverlayView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.subviews.forEach {
            if $0.tag == 1 << 3 {
                $0.removeFromSuperview()
            }
        }
    }
    
    override func setupView() {
        super.setupView()
        
        dateLabel = Label()
        
        datePlaceholderLabel = Label()
        datePlaceholderLabel
            .translatesAutoresizingMaskIntoConstraints = false
        datePlaceholderLabel.heightAnchor
            .constraint(equalToConstant: 44)
            .isActive = true
        datePlaceholderLabel.text = " "
        
        headerRouteInformationView = HeaderRouteInformationView(fromStation: " ", toStation: " ")
        
        headerWithTopBarStackView = UIStackView([datePlaceholderLabel,
                                                 headerRouteInformationView],
                                                axis: .vertical,
                                                distribution: .fill,
                                                alignment: .fill,
                                                spacing: 8)
        
        let headerWithTopBarContainerView = UIView(containingView: headerWithTopBarStackView, withConstaintEquals: [.topSafeArea, .leadingMargin, .trailingMargin, .bottom])
        headerWithTopBarContainerView.preservesSuperviewLayoutMargins = true
        
        
        let headerWithTopBarContainerViewWidthConstraint = headerWithTopBarContainerView.widthAnchor.constraint(equalToConstant: DesignSystem.layout.maximumWidth)
        headerWithTopBarContainerViewWidthConstraint.priority = .defaultHigh
        headerWithTopBarContainerViewWidthConstraint.isActive = true
        
        mainContentView = UIView()
        mainContentView.preservesSuperviewLayoutMargins = true
        mainContentView.backgroundColor = .clear
        mainContentView.isHidden = true
        
        mainTableView = UITableView(frame: .zero, style: .plain)
        mainTableView.preservesSuperviewLayoutMargins = true
        mainTableView.showsVerticalScrollIndicator = false
        mainTableView.backgroundColor = .clear
        mainTableView.separatorStyle = .none
        mainTableView.contentInset.top = 12
        mainTableView.contentOffset.y = -12
        mainTableView.delegate = self
        
        let mainTableViewWidthConstraint = mainTableView.widthAnchor.constraint(equalToConstant: DesignSystem.layout.maximumWidth)
        mainTableViewWidthConstraint.priority = .defaultHigh
        mainTableViewWidthConstraint.isActive = true
        
        mainStackView = UIStackView([headerWithTopBarContainerView,
                                     mainContentView,
                                     mainTableView],
                                    axis: .vertical,
                                    distribution: .fill,
                                    alignment: .center,
                                    spacing: 20)
        mainStackView.preservesSuperviewLayoutMargins = true
        
        mainContentView.widthAnchor.constraint(equalTo: mainStackView.widthAnchor).isActive = true
        
        interactivePopOverlayView = InteractivePopOverlayView()
        view.addSubview(interactivePopOverlayView, withConstaintEquals: .edges)
        
        view.addSubview(mainStackView, withConstaintEquals: .edges)
        
        // MARK: Setup Button
        mainCallToActionButton = Button(type: .contained)
        view.addSubview(mainCallToActionButton, withConstaintEquals: .centerHorizontal)
        
        view.addConstraints(toView: mainCallToActionButton, withConstaintGreaterThanOrEquals: [.leadingMargin, .trailingMargin])
        
        view.constraintBottomSafeArea(to: mainCallToActionButton,
                                      withGreaterThanConstant: 16,
                                      minimunConstant: 8)
        
        let mainCallToActionButtonWidthConstraint = mainCallToActionButton.widthAnchor.constraint(equalToConstant: DesignSystem.layout.maximumWidth)
        mainCallToActionButtonWidthConstraint.priority = .defaultHigh
        mainCallToActionButtonWidthConstraint.isActive = true
        
        view.addSubview(dateLabel)
        datePlaceholderLabel
            .addConstraints(toView: dateLabel,
                            withConstaintEquals: .center)
        
        backButton = BackButtonControl()
        view.addSubview(backButton)
        backButton
            .centerYAnchor
            .constraint(equalTo:
                datePlaceholderLabel
                    .centerYAnchor)
            .isActive = true
        backButton
            .leadingAnchor
            .constraint(equalTo:
                datePlaceholderLabel
                .leadingAnchor,
                        constant: -10)
            .isActive = true
        
        setHeaderInformationValue(headerInformation)
        
    }
    
    override func setupTheme() {
        super.setupTheme()
        
        mainCallToActionButton.setupTheme()
        backButton.setupTheme()
        headerRouteInformationView.setupTheme()
        mainTableView.setupTheme()
        interactivePopOverlayView.setupTheme()
        
        dateLabel.textStyle = textStyle.headline()
        dateLabel.textAlignment = .center
        dateLabel.textColor = currentColorTheme.componentColor.primaryText
        
        datePlaceholderLabel.textStyle = dateLabel.textStyle
        
    }
    
    override func setupInteraction() {
        super.setupInteraction()
        let screenEdgePanGesture =
            UIScreenEdgePanGestureRecognizer(target: self,
                                             action: #selector(screenEdgePanGestureDidPan))
        screenEdgePanGesture.edges = .left
        view.addGestureRecognizer(screenEdgePanGesture)
    }
    
    func setHeaderInformationValue(_ headerInformation: HeaderInformation?) {
        guard let headerInformation = headerInformation,
            let dateLabel = dateLabel,
            let headerRouteInformationView = headerRouteInformationView else { return }
        
        dateLabel.text = "\(headerInformation.dayOfWeek), \(headerInformation.date)"
        headerRouteInformationView.setupValue(fromStation: headerInformation.fromStation,
                                              fromTime: headerInformation.fromTime,
                                              toStation: headerInformation.toStation,
                                              toTime: headerInformation.toTime,
                                              trainNumber: headerInformation.trainNumber,
                                              trainName: headerInformation.trainName,
                                              carNumber: headerInformation.carNumber,
                                              className: headerInformation.className,
                                              seatNumber: headerInformation.seatNumber,
                                              price: headerInformation.price)
    }
    
    func showErrorMessage(_ message: String, delay: TimeInterval = 3) {
        view.subviews.forEach {
            if $0.tag == 1 << 3 {
                $0.removeFromSuperview()
            }
        }
        let containerView = UIView()
        containerView.tag = 1 << 3
        containerView.preservesSuperviewLayoutMargins = true
        containerView.backgroundColor = currentColorTheme.componentColor.errorBackground
        view.addSubview(containerView,
                        withConstaintEquals: [.top,
                                              .leading,
                                              .trailing])
        
        let label = Label()
        label.textStyle = textStyle.caption1()
        label.numberOfLines = 0
        label.textColor = currentColorTheme.componentColor.primaryText
        label.textAlignment = .center
        label.text = message
        
        containerView.addSubview(label,
                                 withConstaintEquals: [.topMargin,
                                                       .bottomMargin,
                                                       .centerHorizontal],
                                 insetsConstant: .init(bottom: 8))
        containerView.addConstraints(toView: label,
                                     withConstaintGreaterThanOrEquals: [.leadingMargin, .trailingMargin])
        let labelWidthConstraint = label.widthAnchor.constraint(equalToConstant: DesignSystem.layout.maximumWidth)
        labelWidthConstraint.priority = .defaultHigh
        labelWidthConstraint.isActive = true
        
        /// Animating Container View
        containerView.layoutIfNeeded()
        containerView.transform.ty = -containerView.bounds.height
        UIView.animate(withStyle: .normalAnimationStyle,
                       animations: {
                        
                        containerView.transform.ty = 0
                        
        }, completion: {
            finished in
            
            UIView.animate(withStyle: .normalAnimationStyle,
                           delay: delay,
                           animations: {
                            containerView.transform.ty = -containerView.bounds.height
            },
                           completion: {
                            finished in
                            containerView.removeFromSuperview()
            })
        })
        
    }
    
    @objc func screenEdgePanGestureDidPan(_ sender: UIScreenEdgePanGestureRecognizer) {
        /// Make it only work with the compact trait
        guard traitCollection.horizontalSizeClass == .compact,
            self != navigationController?.viewControllers[0],
            !isPopPerforming else { return }
        
        view.bringSubviewToFront(interactivePopOverlayView)
        let state = sender.state
        
        let location = sender.location(in: sender.view!)
        let translate = CGPoint(x: max(sender.translation(in: sender.view!).x, 0),
                                y: location.y)
        let velocity = sender.velocity(in: sender.view!)
        let dismissXTranslateThreshold: CGFloat = view.bounds.width / 3
        let alphaXTranslateThreshold: CGFloat = dismissXTranslateThreshold
        
        interactivePopOverlayView.dismissXTranslateThreshold = dismissXTranslateThreshold
        
        func setAlpha(to alpha: CGFloat) {
            interactivePopOverlayView.overlayAlpha = 1 - alpha
        }
        
        switch state {
        case .changed:
            if !isPopPerforming {
                backButton.transform.tx = min(translate.x / 3, view.bounds.width / 9)
                
                let alpha = max(((1 - DesignSystem.alpha.disabled) *
                    (1 - translate.x / alphaXTranslateThreshold)), 0) +
                    DesignSystem.alpha.disabled
                
                setAlpha(to: alpha)
                
                interactivePopOverlayView.currentTranslation = translate
            }
            
        case .ended:
            interactivePopOverlayView.currentTranslation?.x = 0
            if velocity.x > 72 {
                isPopPerforming = true
            } else {
                if translate.x > dismissXTranslateThreshold {
                    isPopPerforming = true
                } else {
                    UIView
                        .animate(withStyle: .normalAnimationStyle,
                                 animations: {
                                    [weak self] in
                                    self?.backButton.transform.tx = 0
                                    
                                    setAlpha(to: 1)
                        })
                }
            }
        default:
            break
        }
    }
}

extension BookingViewController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let verticalContentOffset = scrollView.contentOffset.y + scrollView.contentInset.top
       
        if !isPopPerforming {
            headerRouteInformationView.verticalRubberBandEffect(byVerticalContentOffset: verticalContentOffset)
        }
    }
}
