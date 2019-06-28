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
                    self?.callToActionLabelView.transform.tx = self?.isReadyToPop ?? false ? 0 : -(self?.callToActionLabelView.bounds.width ?? 64)
                    self?.callToActionLabelView.alpha = self?.isReadyToPop ?? false ? 1 : 0
                })
            }
        }
    }
    
    var overlayView: UIView!
    
    var callToActionLabelView: UIView!
    
    var dismissXTranslateThreshold: CGFloat = 0
    
    var overlayAlpha: CGFloat = 0 {
        didSet {
            overlayView.alpha = overlayAlpha
        }
    }
    
    var currentTranslation: CGPoint? {
        didSet {
            isReadyToPop = currentTranslation?.x ?? 0 > dismissXTranslateThreshold
            
            callToActionLabelView.transform.ty = currentTranslation?.y ?? 0
        }
    }
    
    init() {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        
        backgroundColor = .clear
        isUserInteractionEnabled = false
        preservesSuperviewLayoutMargins = true
        
        overlayView = UIView()
        overlayView.backgroundColor = currentColorTheme.componentColor.background
        overlayView.alpha = 0
        addSubview(overlayView, withConstaintEquals: .edges)
        
        callToActionLabelView = UIView()
        addSubview(callToActionLabelView, withConstaintEquals: [.leadingMargin])
        topAnchor.constraint(equalTo: callToActionLabelView.centerYAnchor).isActive = true
        
        let label = Label()
        label.textStyle = textStyle.body()
        label.textColor = currentColorTheme.componentColor.primaryText
        label.text = "← Back"
        callToActionLabelView.addSubview(label, withConstaintEquals: .edges)
        callToActionLabelView.layoutIfNeeded()
        callToActionLabelView.transform.tx = -callToActionLabelView.bounds.width
        callToActionLabelView.alpha = 0
        
    }
}
