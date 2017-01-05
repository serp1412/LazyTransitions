//
//  PartialTransitionAnimator.swift
//  Wadi
//
//  Created by Yopeso on 7/8/16.
//  Copyright © 2016 YOPESO. All rights reserved.
//

import UIKit

class PartialTransitionAnimator: NSObject {
    weak var delegate : TransitionAnimatorDelegate?
    var orientation : TransitionOrientation
    var speed : Float
    var allowedOrientations: [TransitionOrientation]?
    var supportedOrientations: [TransitionOrientation] = [.topToBottom, .bottomToTop, .leftToRight, .rightToLeft]
    init(orientation: TransitionOrientation, speed: Float) {
        self.orientation = orientation
        self.speed = speed
    }
    
    required init(orientation: TransitionOrientation) {
        self.orientation = orientation
        self.speed = 0
    }
}

extension PartialTransitionAnimator: TransitionAnimator {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.2
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard isOrientationAllowed,
            let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from),
            let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
            else { return }
        
        let containerView = transitionContext.containerView
        containerView.insertSubview(toVC.view, belowSubview: fromVC.view)
        
        var adjustmentRatio = CGFloat(self.speed / 25)
        
        if adjustmentRatio > 0.3 {
            adjustmentRatio = 0.3
        }
        
        let startingFrame = fromVC.view.frame
        let finalFrame = self.finalFrame(for: fromVC.view, for: orientation)
        let adjustedFrame = CGRect(x: finalFrame.origin.x * adjustmentRatio, y: finalFrame.origin.y * adjustmentRatio, width: finalFrame.size.width, height: finalFrame.size.height)
        
        let shadowView = UIView()
        shadowView.frame = UIScreen.main.bounds
        
        shadowView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
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
    
    func animationEnded(_ transitionCompleted: Bool) {
        delegate?.transitionDidFinish(transitionCompleted)
    }
}
