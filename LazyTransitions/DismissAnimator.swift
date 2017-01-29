//
//  DismissAnimator.swift
//  LazyTransitions
//
//  Created by BeardWare on 6/29/16.
//  Copyright © 2016 BeardWare. All rights reserved.
//

import UIKit

public class DismissAnimator: NSObject {
    weak public var delegate : TransitionAnimatorDelegate?
    public var orientation : TransitionOrientation
    public var allowedOrientations: [TransitionOrientation]?
    required public init(orientation: TransitionOrientation) {
        self.orientation = orientation
    }
}

extension DismissAnimator: TransitionAnimatorType {
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard isOrientationAllowed,
            let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from),
            let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
            else { return }
        
        let containerView = transitionContext.containerView
        containerView.insertSubview(toVC.view, belowSubview: fromVC.view)
        
        let finalFrame = self.finalFrame(for: fromVC.view, for: orientation)
        let shadowView = UIView.shadowView
        
        containerView.insertSubview(shadowView, aboveSubview: toVC.view)
        
        UIView.animate(
            withDuration: transitionDuration(using: transitionContext),
            animations: {
                fromVC.view.frame = finalFrame
                shadowView.alpha = 0
        },
            completion: { _ in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                shadowView.removeFromSuperview()
        })
    }
    
    public func animationEnded(_ transitionCompleted: Bool) {
        delegate?.transitionDidFinish(transitionCompleted)
    }
}
