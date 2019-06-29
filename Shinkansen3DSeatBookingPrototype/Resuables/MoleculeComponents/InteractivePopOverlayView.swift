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
            var offsetX: CGFloat
            if translation.x > offsetTouchAreaCallToActionBackgroundX {
                let maxWidth = dismissXTranslateThreshold + offsetTouchAreaCallToActionBackgroundX
                
                if translation.x < maxWidth - offsetTouchAreaCallToActionBackgroundX {
                    offsetX = translation.x + offsetTouchAreaCallToActionBackgroundX
                } else {
                    offsetX = maxWidth * ( sqrt((translation.x + offsetTouchAreaCallToActionBackgroundX) / maxWidth))
                }
            } else {
                offsetX = translation.x * 2
            }
            setCallToActionBackgroundViewAppearance(by: CGPoint(x: offsetX,
                                                                y: translation.y))
        }
    }
    
    private var offsetTouchAreaCallToActionBackgroundX: CGFloat = 40
    
    private var offsetCallToActionBackgroundX: CGFloat = 32
    
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
        callToActionContainerView.preservesSuperviewLayoutMargins = true
        addSubview(callToActionContainerView, withConstaintEquals: [.leading, .trailing])
        callToActionContainerView.centerYAnchor.constraint(equalTo: topAnchor).isActive = true
        layoutIfNeeded()
        callToActionContainerView.heightAnchor.constraint(greaterThanOrEqualToConstant: UIScreen.main.bounds.height).isActive = true
        
        callToActionBackgroundView = UIView()
        callToActionContainerView
            .addSubview(callToActionBackgroundView,
                        withConstaintEquals: .centerVertical)
        callToActionBackgroundView
            .centerXAnchor
            .constraint(equalTo: callToActionContainerView.leadingAnchor,
                        constant:  -offsetCallToActionBackgroundX)
            .isActive = true
        let sizeRatioToViewHeight: CGFloat = 1.125
        callToActionBackgroundView.heightAnchor
            .constraint(equalTo: callToActionContainerView.heightAnchor,
                        multiplier: sizeRatioToViewHeight)
            .isActive = true
        callToActionBackgroundView.widthAnchor
            .constraint(equalTo: callToActionContainerView.heightAnchor,
                        multiplier: sizeRatioToViewHeight)
            .isActive = true
        
        callToActionLabel = Label()
        callToActionLabel.text = "←  Previous"
        addSubview(callToActionLabel,
                   withConstaintEquals: [.leadingMargin,
                                         .centerVertical])
    }
    
    func setupTheme() {
        
        overlayView.backgroundColor = currentColorTheme.componentColor.background
        
        callToActionLabel.textStyle = textStyle.button()
        callToActionLabel.textColor = currentColorTheme.componentColor.contentOnCallToAction
        callToActionLabel.transform.tx = -callToActionLabel.bounds.width / 2
        callToActionLabel.alpha = 0
        
        callToActionContainerView.layoutIfNeeded()
        callToActionBackgroundView.backgroundColor = currentColorTheme.componentColor.callToAction
        callToActionBackgroundView.layer.cornerRadius = callToActionBackgroundView.bounds.height / 2
        callToActionBackgroundView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        setCallToActionBackgroundViewAppearance(by: .zero)
    }
    
    private func setCallToActionBackgroundViewAppearance(by location: CGPoint) {
        
        let scaleX = (location.x + offsetCallToActionBackgroundX) / (callToActionBackgroundView.bounds.width) * 2
        let scaleY = abs((location.y / bounds.height) - 0.5) * 1.5 + 1
        callToActionBackgroundView
            .transform =
            CGAffineTransform(scaleX: scaleX, y: scaleY)
        
        let alpha = min(location.x / dismissXTranslateThreshold, 1)
        callToActionBackgroundView.alpha = alpha * DesignSystem.alpha.highlighted
    }
}
