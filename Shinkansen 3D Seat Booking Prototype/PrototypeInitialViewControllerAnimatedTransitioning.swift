//
//  PrototypeInitialViewControllerAnimatedTransition.swift
//  Shinkansen 3D Seat Booking Prototype
//
//  Created by Virakri Jinangkul on 6/21/19.
//  Copyright © 2019 Virakri Jinangkul. All rights reserved.
//

import UIKit
import Kumi

class PrototypeInitialViewControllerAnimatedTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    lazy var animationStyle: UIViewAnimationStyle = UIViewAnimationStyle
        .transitionAnimationStyle
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return animationStyle.duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let container = transitionContext.containerView
        container.backgroundColor = UIColor.basic.white
        
        guard let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from) else { return }
        guard let toView = transitionContext.view(forKey: UITransitionContextViewKey.to) else { return }
        
        container.addSubview(toView)
        
        toView.alpha = 0
        
        UIView.animate(withStyle: .halfTransitionAnimationStyle, animations: {
            fromView.alpha = 0
        }, completion: {
            _ in
            UIView.animate(withStyle: .halfTransitionAnimationStyle, animations: {
                toView.alpha = 1
            }, completion: {
                _ in transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
        })
    }
    
    
}
