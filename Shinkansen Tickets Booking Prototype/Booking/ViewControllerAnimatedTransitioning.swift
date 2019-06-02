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
            
            func animate(fromView: UIView, fromParentView: UIView,
                     toView: UIView, toParentView: UIView,
                     basedHorizontalAnimationOffset: CGFloat = 0,
                     basedVerticalAnimationOffset: CGFloat = 0) {
                
                // Sets all animated views to orginal position before them get calculated
                fromView.transform = .identity
                toView.transform = .identity
                
                var displacement: CGPoint = .zero
                
                if fromView.isHidden || toView.isHidden {
                    
                    // MARK: Hidden views will be slide up
                    if fromView.isHidden  {
                        displacement.x = CGFloat(-basedHorizontalAnimationOffset).systemSizeMuliplier()
                        displacement.y = CGFloat(-basedVerticalAnimationOffset).systemSizeMuliplier()
                    }
                    
                    if toView.isHidden  {
                        displacement.x = CGFloat(basedHorizontalAnimationOffset).systemSizeMuliplier()
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
                
                //TEMP
                fromBookingVC.mainContentView.alpha = 0
                toBookingVC.mainContentView.alpha = 0
                
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
                    
                    fromBookingVC.mainContentView.alpha = 1
                    toBookingVC.mainContentView.alpha = 1
                })
            }
            
            guard let fromHeaderView = fromBookingVC.headerRouteInformationView,
                let toHeaderView = toBookingVC.headerRouteInformationView else { return }
            
            guard let fromDateView = fromBookingVC.dateLabelSetView,
                let toDateView = toBookingVC.dateLabelSetView else { return }
            
            let fromParentView = fromBookingVC.view!
            let toParentView = toBookingVC.view!
            
            animate(fromView: fromDateView,
                fromParentView: fromParentView,
                toView: toDateView,
                toParentView: toParentView,
                basedVerticalAnimationOffset: 18)
            
            animate(fromView: fromHeaderView, fromParentView: fromParentView,
                toView: toHeaderView, toParentView: toParentView,
                basedVerticalAnimationOffset: 64)
            
            animate(fromView: fromHeaderView.stationPairView.fromStationHeadlineView.subtitleLabel,
                fromParentView: fromHeaderView.stationPairView.fromStationHeadlineView,
                toView: toHeaderView.stationPairView.fromStationHeadlineView.subtitleLabel,
                toParentView: toHeaderView.stationPairView.fromStationHeadlineView,
                basedVerticalAnimationOffset: 6)
            
            animate(fromView: fromHeaderView.stationPairView.toStationHeadlineView.subtitleLabel,
                fromParentView: fromHeaderView.stationPairView.toStationHeadlineView,
                toView: toHeaderView.stationPairView.toStationHeadlineView.subtitleLabel,
                toParentView: toHeaderView.stationPairView.toStationHeadlineView,
                basedVerticalAnimationOffset: 6)
            
            animate(fromView: fromHeaderView.descriptionSetView, fromParentView: fromHeaderView,
                toView: toHeaderView.descriptionSetView, toParentView: toHeaderView,
                basedVerticalAnimationOffset: 18)
            
            animate(fromView: fromHeaderView.descriptionSetView.carNumberSetView,
                fromParentView: fromHeaderView.descriptionSetView,
                toView: toHeaderView.descriptionSetView.carNumberSetView,
                toParentView: toHeaderView.descriptionSetView,
                basedVerticalAnimationOffset: 12)
            
            animate(fromView: fromHeaderView.descriptionSetView.seatNumberSetView,
                fromParentView: fromHeaderView.descriptionSetView,
                toView: toHeaderView.descriptionSetView.seatNumberSetView,
                toParentView: toHeaderView.descriptionSetView,
                basedVerticalAnimationOffset: 12)
            
            animate(fromView: fromHeaderView.descriptionSetView.priceSetView,
                fromParentView: fromHeaderView.descriptionSetView,
                toView: toHeaderView.descriptionSetView.priceSetView,
                toParentView: toHeaderView.descriptionSetView,
                basedVerticalAnimationOffset: 12)
            
            print(fromBookingVC.mainTableView.visibleCells)
            print(toBookingVC.mainTableView.visibleCells)
            
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
