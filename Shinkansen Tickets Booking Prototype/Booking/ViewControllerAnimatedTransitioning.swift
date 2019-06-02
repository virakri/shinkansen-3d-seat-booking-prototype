//
//  ViewControllerAnimatedTransitioning.swift
//  Shinkansen Tickets Booking Prototype
//
//  Created by Virakri Jinangkul on 6/2/19.
//  Copyright © 2019 Virakri Jinangkul. All rights reserved.
//

import UIKit
import Kumi

class ViewControllerAnimatedTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
    
    var isPresenting : Bool
    
    lazy var animationStyle: UIViewAnimationStyle = {
        UIViewAnimationStyle.transitionAnimationStyle
    }()
    
    lazy var CAAnimationStyle: CABasicAnimationStyle = {
        CABasicAnimationStyle.transitionAnimationStyle
    }()
    
    init(isPresenting : Bool) {
        self.isPresenting = isPresenting
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return animationStyle.duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)
        
        let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        
        let container = transitionContext.containerView
        
        guard let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from) else { return }
        guard let toView = transitionContext.view(forKey: UITransitionContextViewKey.to) else { return }
        
        isPresenting ? container.addSubview(toView) : container.insertSubview(toView, belowSubview: fromView)
        
        
        let parentVC = isPresenting ? fromViewController : toViewController
        
        let childVC = isPresenting ? toViewController : fromViewController
        
        // MARK: Set all the views in place and have been processed thru Autolayout
        parentVC?.view.layoutIfNeeded()
        childVC?.view.layoutIfNeeded()
        
        // MARK: Transition Between BookingViewController
        if let fromBookingVC = fromViewController as? BookingViewController,
            let toBookingVC = toViewController as? BookingViewController {
            print("Parent: \(fromBookingVC.headerRouteInformationView.frame)")
            print("Child: \(toBookingVC.headerRouteInformationView.frame)")
            
           
            
            // Temporary testing animation
            
            func xxx(fromView: UIView, fromParentView: UIView,
                     toView: UIView, toParentView: UIView,
                     basedVerticalAnimationOffset: CGFloat = 0) {
                fromView.transform = .identity
                toView.transform = .identity
                
                var displacement: CGPoint = .zero
                
                if fromView.isHidden || toView.isHidden {
                    
                    // MARK: Hidden views will be slide up
                    if fromView.isHidden  {
                        displacement.y = CGFloat(-basedVerticalAnimationOffset).systemSizeMuliplier()
                    }
                    
                    if toView.isHidden  {
                        displacement.y = CGFloat(basedVerticalAnimationOffset).systemSizeMuliplier()
                    }
                    
                } else {
                    let fromActualFrame = fromView.frame(in: fromParentView)
                    let toActualFrame = toView.frame(in: toParentView)
                    
                    displacement = CGPoint(x: toActualFrame.midX - fromActualFrame.midX,
                                           y: toActualFrame.minY - fromActualFrame.minY)
                }
                
                toView.transform.tx = -displacement.x
                toView.transform.ty = -displacement.y
                
                // MARK: In case one view is hidden
                if fromView.isHidden  {
                    toView.alpha = 0
                }
                
                if toView.isHidden  {
                    fromView.alpha = 1
                }
                
                UIView.animate(withStyle: animationStyle, animations: {
                    fromView.transform.tx = displacement.x
                    fromView.transform.ty = displacement.y
                    toView.transform = .identity
                    
                    // MARK: Animation for one that is hidden
                    if fromView.isHidden {
                        toView.alpha = 1
                    }
                    
                    if toView.isHidden {
                        fromView.alpha = 0
                    }
                })
            }
            
            guard let fromView = fromBookingVC.headerRouteInformationView,
                let toView = toBookingVC.headerRouteInformationView else { return }
            
            let fromParentView = fromBookingVC.view!
            let toParentView = toBookingVC.view!
            
            xxx(fromView: fromView, fromParentView: fromParentView,
                toView: toView, toParentView: toParentView,
                basedVerticalAnimationOffset: 64)
            
            xxx(fromView: fromView.stationPairView.fromStationHeadlineView.subtitleLabel,
                fromParentView: fromView.stationPairView.fromStationHeadlineView,
                toView: toView.stationPairView.fromStationHeadlineView.subtitleLabel,
                toParentView: toView.stationPairView.fromStationHeadlineView,
                basedVerticalAnimationOffset: 6)
            
            xxx(fromView: fromView.stationPairView.toStationHeadlineView.subtitleLabel,
                fromParentView: fromView.stationPairView.toStationHeadlineView,
                toView: toView.stationPairView.toStationHeadlineView.subtitleLabel,
                toParentView: toView.stationPairView.toStationHeadlineView,
                basedVerticalAnimationOffset: 6)
            
            xxx(fromView: fromView.descriptionSetView, fromParentView: fromView,
                toView: toView.descriptionSetView, toParentView: toView,
                basedVerticalAnimationOffset: 18)
        }
        
        toView.backgroundColor = toView.backgroundColor?.withAlphaComponent(0)
        
        
        
        // MARK: Perform Animation
        UIView
            .animate(withStyle: animationStyle,
                     animations: {
                        toView.backgroundColor = toView.backgroundColor?.withAlphaComponent(1)
            },
                     completion: {
                        finished in
                        transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
        
        
    }
}
