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
                    self?.callToActionLabelContainerView.transform.tx = self?.isReadyToPop ?? false ? 0 : -(self?.callToActionLabelContainerView.bounds.width ?? 64)
                    self?.callToActionLabelContainerView.alpha = self?.isReadyToPop ?? false ? 1 : 0
                })
            }
        }
    }
    
    var overlayView: UIView!
    
    var callToActionLabelContainerView: UIView!
    
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
            
//            callToActionLabelView.transform.ty = currentTranslation?.y ?? 0
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
        
        callToActionLabelContainerView = UIView()
        callToActionLabelContainerView.preservesSuperviewLayoutMargins = true
        addSubview(callToActionLabelContainerView, withConstaintEquals: [.leading, .centerVertical])
        
        callToActionLabel = Label()
        callToActionLabel.text = "← Back"
        callToActionLabelContainerView.addSubview(callToActionLabel, withConstaintEquals: .marginEdges)
        
        callToActionLabelContainerView.alpha = 0
    }
    
    func setupTheme() {
        
        overlayView.backgroundColor = currentColorTheme.componentColor.background
        
        callToActionLabel.textStyle = textStyle.body()
        callToActionLabel.textColor = currentColorTheme.componentColor.contentOnCallToAction
        
        callToActionLabelContainerView.backgroundColor = currentColorTheme.componentColor.callToAction
        callToActionLabelContainerView.layoutIfNeeded()
        callToActionLabelContainerView.directionalLayoutMargins.trailing = callToActionLabelContainerView.bounds.height / 2
        callToActionLabelContainerView.layer.cornerRadius = callToActionLabelContainerView.bounds.height / 2
        callToActionLabelContainerView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        callToActionLabelContainerView.transform.tx = -callToActionLabelContainerView.bounds.width
    }
}
