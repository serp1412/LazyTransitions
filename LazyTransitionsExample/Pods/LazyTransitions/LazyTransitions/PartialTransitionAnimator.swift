//
//  PartialTransitionAnimator.swift
//  LazyTransitions
//
//  Created by BeardWare on 7/8/16.
//  Copyright © 2016 BeardWare. All rights reserved.
//

import UIKit

public class PartialTransitionAnimator: NSObject {
    public weak var delegate : TransitionAnimatorDelegate?
    public var orientation : TransitionOrientation
    public var speed : CGFloat
    public var allowedOrientations: [TransitionOrientation]?
    public var supportedOrientations: [TransitionOrientation] = [.topToBottom, .bottomToTop, .leftToRight, .rightToLeft]
    public init(orientation: TransitionOrientation, speed: CGFloat) {
        self.orientation = orientation
        self.speed = speed
    }
    
    public required init(orientation: TransitionOrientation) {
        self.orientation = orientation
        self.speed = 0
    }
}

extension PartialTransitionAnimator: TransitionAnimatorType {
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.2
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard isOrientationAllowed,
            let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from),
            let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
            else { return }
        
        let containerView = transitionContext.containerView
        containerView.insertSubview(toVC.view, belowSubview: fromVC.view)
        
        var adjustmentRatio = self.speed / 25
        
        if adjustmentRatio > 0.3 {
            adjustmentRatio = 0.3
        }
        
        let startingFrame = fromVC.view.frame
        let finalFrame = self.finalFrame(for: fromVC.view, for: orientation)
        let adjustedFrame = CGRect(x: finalFrame.origin.x * adjustmentRatio, y: finalFrame.origin.y * adjustmentRatio, width: finalFrame.size.width, height: finalFrame.size.height)
        
        let shadowView = UIView.shadowView
        
        containerView.insertSubview(shadowView, aboveSubview: toVC.view)
        
        let options: UIViewAnimationOptions = [.curveEaseOut]
        
        
        UIView.animate(withDuration: 0.15, delay: 0, options: options, animations: {
            fromVC.view.frame = adjustedFrame
            shadowView.alpha = 0.7
        }, completion: { _ in
            UIView.animate(withDuration: 0.15, delay: 0, options: UIViewAnimationOptions(), animations: {
                fromVC.view.frame = startingFrame
                shadowView.alpha = 1
            }, completion: { _ in
                transitionContext.completeTransition(false)
                shadowView.removeFromSuperview()
            })
        })
    }
    
    public func animationEnded(_ transitionCompleted: Bool) {
        delegate?.transitionDidFinish(transitionCompleted)
    }
}
