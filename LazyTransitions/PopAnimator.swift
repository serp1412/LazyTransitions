//
//  PopAnimator.swift
//  LazyTransitions
//
//  Created by Serghei Catraniuc on 12/5/16.
//  Copyright © 2016 BeardWare. All rights reserved.
//

import Foundation

public class PopAnimator: NSObject {
    public weak var delegate : TransitionAnimatorDelegate?
    public var orientation: TransitionOrientation
    public var allowedOrientations: [TransitionOrientation]?
    public required init(orientation: TransitionOrientation) {
        self.orientation = orientation
    }
    public var supportedOrientations: [TransitionOrientation] {
        return [.leftToRight, .rightToLeft]
    }
}

extension PopAnimator: TransitionAnimatorType {
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard isOrientationSupported,
            isOrientationAllowed,
            let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from),
            let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
            else { return }
        
        let containerView = transitionContext.containerView
        containerView.insertSubview(toVC.view, belowSubview: fromVC.view)
        
        let shadowView = UIView.shadowView
        
        containerView.insertSubview(shadowView, aboveSubview: toVC.view)
        
        var fromX: CGFloat = 0
        var toX: CGFloat = 0
        
        if orientation == .rightToLeft {
            fromX = -fromVC.view.frame.width
            toX = toVC.view.frame.width / 2
        } else {
            fromX = fromVC.view.frame.width
            toX = -(toVC.view.frame.width / 2)
        }
        
        let finalFromFrame = CGRect(x: fromX, y: fromVC.view.frame.origin.y, width: fromVC.view.frame.width, height: fromVC.view.frame.height)
        let startingToFrame = CGRect(x: toX, y: toVC.view.frame.origin.y, width: toVC.view.frame.width, height: toVC.view.frame.height)
        
        let finalToFrame = fromVC.view.frame
        toVC.view.frame = startingToFrame
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            fromVC.view.frame = finalFromFrame
            toVC.view.frame = finalToFrame
            shadowView.alpha = 0
        }, completion: { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            shadowView.removeFromSuperview()
        })
    }
    
    public func animationEnded(_ transitionCompleted: Bool) {
        delegate?.transitionDidFinish(transitionCompleted)
    }
}
