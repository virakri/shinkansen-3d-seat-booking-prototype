//
//  SceneKitAnimator.swift
//  Face-based Game Prototype
//
//  Created by VIRAKRI JINANGKUL on 10/27/17.
//  Copyright © 2017 VIRAKRI JINANGKUL. All rights reserved.
//

import SceneKit
import UIKit

public extension CAMediaTimingFunction {
    
    static let linear = CAMediaTimingFunction(controlPoints: 0, 0, 1, 1)
    
    static let easeIn = CAMediaTimingFunction(controlPoints: 0.9, 0, 0.9, 1)
    
    static let easeOut = CAMediaTimingFunction(controlPoints: 0.1, 0, 0.1, 1)
    
    static let easeInOut = CAMediaTimingFunction(controlPoints: 0.45, 0, 0.55, 1)
    
    static let easeInEaseOut = CAMediaTimingFunction(controlPoints: 0.42, 0, 0.58, 1)
    
    static let explodingEaseOut = CAMediaTimingFunction(controlPoints: 0, 0, 0, 1)
    
    static let `default` = CAMediaTimingFunction(controlPoints: 0, 0, 0.2, 1)
    
}

public class SceneKitAnimator {
    
    var completed: (() -> Void)?
    
    @discardableResult
    /// A block object wrapping animations and combining scene graph changes into atomic updates.
    ///
    /// - Parameters:
    ///   - duration: The total duration of the animations, measured in seconds. If you specify a negative value or 0, the changes are made without animating them.
    ///   - timingFunction: A function that defines the pacing of an animation as a timing curve.
    ///   - animated: A boolean value that determines if this animation expected to perform or not. The defualt value of this property is true.
    ///   - animations: A block object containing the changes to commit to the views. This is where you programmatically change any animatable properties of the views in your view hierarchy. This block takes no parameters and has no return value. This parameter must not be NULL.
    ///   - completion: A block object to be executed when the animation sequence ends. This block has no return value and takes a single Boolean argument that indicates whether or not the animations actually finished before the completion handler was called. If the duration of the animation is 0, this block is performed at the beginning of the next run loop cycle. This parameter may be NULL.
    /// - Returns: The object wrapping SceneKit animation.
    public class func animateWithDuration(duration: TimeInterval,
                                          timingFunction: CAMediaTimingFunction = .default,
                                          animated: Bool = true,
                                          animations: (() -> Void),
                                          completion: (() -> Void)? = nil) -> SceneKitAnimator{
        let promise = SceneKitAnimator()
        SCNTransaction.begin()
        SCNTransaction.completionBlock = { [weak promise] in
            completion?()
            promise?.completed?()
            
        }
        SCNTransaction.animationTimingFunction = timingFunction
        SCNTransaction.animationDuration = duration
        animations()
        SCNTransaction.commit()
        return promise
    }
    
    @discardableResult
    /// A block object wrapping animations and combining scene graph changes into atomic updates.
    ///
    /// - Parameters:
    ///   - duration: The total duration of the animations, measured in seconds. If you specify a negative value or 0, the changes are made without animating them.
    ///   - timingFunction: A function that defines the pacing of an animation as a timing curve.
    ///   - animated: A boolean value that determines if this animation expected to perform or not. The defualt value of this property is true.
    ///   - animations: A block object containing the changes to commit to the views. This is where you programmatically change any animatable properties of the views in your view hierarchy. This block takes no parameters and has no return value. This parameter must not be NULL.
    ///   - completion: A block object to be executed when the animation sequence ends. This block has no return value and takes a single Boolean argument that indicates whether or not the animations actually finished before the completion handler was called. If the duration of the animation is 0, this block is performed at the beginning of the next run loop cycle. This parameter may be NULL.
    /// - Returns: The object wrapping SceneKit animation.
    public func thenAnimateWithDuration(duration: TimeInterval,
                                        timingFunction: CAMediaTimingFunction = .default,
                                        animated: Bool = true,
                                        animations: @escaping (() -> Void),
                                        completion: (() -> Void)? = nil) -> SceneKitAnimator {
        let animator = SceneKitAnimator()
        completed = { [weak animator] in
            SceneKitAnimator.animateWithDuration(duration: duration,
                                                 timingFunction: timingFunction,
                                                 animated: animated,
                                                 animations: animations,
                                                 completion: {
                                                    animator?.completed?()
                                                    completion?()
            })
        }
        return animator
    }
    
}
