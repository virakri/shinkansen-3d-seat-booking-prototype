//
//  interactivePopOverlayView.swift
//  Shinkansen3DSeatBookingPrototype
//
//  Created by Virakri Jinangkul on 6/28/19.
//  Copyright © 2019 Virakri Jinangkul. All rights reserved.
//

import UIKit

class InteractivePopOverlayView: UIView {
    
    static let feedbackGenerator = UISelectionFeedbackGenerator()
    
    var isReadyToPop: Bool = false {
        didSet {
            if oldValue != isReadyToPop {
                InteractivePopOverlayView.feedbackGenerator.selectionChanged()
                
                UIView.animate(withStyle: .normalAnimationStyle, animations: {
                    [weak self] in
                    self?.callToActionLabel.transform.tx = self?.isReadyToPop ?? false ? 0 : -(self?.callToActionLabel.bounds.width ?? 64) / 2
                    self?.callToActionLabel.alpha = self?.isReadyToPop ?? false ? 1 : 0
                })
            }
        }
    }
    
    var overlayView: UIView!
    
    var callToActionContainerView: UIView!
    
    var callToActionBackgroundView: UIView!
    
    var callToActionLabel: Label!
    
    var dismissXTranslateThreshold: CGFloat = 0
    
    var overlayAlpha: CGFloat = 0 {
        didSet {
            overlayView.alpha = overlayAlpha
        }
    }
    
    var currentTranslation: CGPoint? {
        didSet {
            isReadyToPop = currentTranslation?.x ?? 0 > dismissXTranslateThreshold
            let translation = currentTranslation ?? CGPoint.zero
            callToActionContainerView.transform.ty = translation.y
            if translation.x > 48 {
                let maxWidth = callToActionLabel.bounds.width + callToActionContainerView.bounds.height / 2 + 16
                if translation.x < maxWidth - 48 {
                    callToActionBackgroundView.transform.tx = translation.x - callToActionBackgroundView.bounds.width + 48
                } else {
                    callToActionBackgroundView.transform.tx = maxWidth - callToActionBackgroundView.bounds.width
                }
                
            } else {
                callToActionBackgroundView.transform.tx = translation.x * 2 - callToActionBackgroundView.bounds.width
            }
        }
    }
    
    init() {
        super.init(frame: .zero)
        setupView()
        setupTheme()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        
        backgroundColor = .clear
        isUserInteractionEnabled = false
        preservesSuperviewLayoutMargins = true
        
        overlayView = UIView()
        overlayView.alpha = 0
        addSubview(overlayView, withConstaintEquals: .edges)
        
        callToActionContainerView = UIView()
        callToActionContainerView.clipsToBounds = true
        callToActionContainerView.preservesSuperviewLayoutMargins = true
        addSubview(callToActionContainerView, withConstaintEquals: [.leading, .trailing])
        callToActionContainerView.centerYAnchor.constraint(equalTo: topAnchor).isActive = true
        callToActionContainerView.heightAnchor.constraint(greaterThanOrEqualToConstant: 80).isActive = true
        
        callToActionBackgroundView = UIView()
        callToActionContainerView.addSubview(callToActionBackgroundView, withConstaintEquals: .edges)
        
        callToActionLabel = Label()
        callToActionLabel.text = "←  Previous Step"
        callToActionContainerView.addSubview(callToActionLabel, withConstaintEquals: [.leadingMargin, .top, .bottom])
    }
    
    func setupTheme() {
        
        overlayView.backgroundColor = currentColorTheme.componentColor.background
        
        callToActionLabel.textStyle = textStyle.button()
        callToActionLabel.textColor = currentColorTheme.componentColor.contentOnCallToAction
        callToActionLabel.transform.tx = -callToActionLabel.bounds.width / 2
        callToActionLabel.alpha = 0
        
        callToActionContainerView.layoutIfNeeded()
        callToActionBackgroundView.backgroundColor = currentColorTheme.componentColor.callToAction
        callToActionBackgroundView.layer.cornerRadius = callToActionContainerView.bounds.height / 2
        callToActionBackgroundView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        
        callToActionBackgroundView.transform.tx = -callToActionBackgroundView.bounds.width
    }
}
