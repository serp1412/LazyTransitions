//
//  InteractiveTransitioner.swift
//  LazyTransitions
//
//  Created by Serghei Catraniuc on 11/30/16.
//  Copyright © 2016 BeardWare. All rights reserved.
//

import Foundation

public class InteractiveTransitioner: InteractiveTransitionerType {
    
    //MARK: Initializers
    
    public required init(with gestureHandler: TransitionGestureHandlerType,
         with animator: TransitionAnimatorType = DismissAnimator(orientation: .topToBottom),
         with interactor: TransitionInteractor = TransitionInteractor.default()) {
        self.gestureHandler = gestureHandler
        self.animator = animator
        self.animator.delegate = self
        self.gestureHandler.delegate = self
        self.interactor = interactor
    }
    
    //MARK: InteractiveTransitioner Protocol
    
    public var gestureHandler: TransitionGestureHandlerType
    public weak var delegate: TransitionerDelegate?
    public var animator: TransitionAnimatorType
    public var interactor: TransitionInteractor?
}

extension InteractiveTransitioner: TransitionGestureHandlerDelegate {
    public func beginInteractiveTransition(with orientation: TransitionOrientation) {
        guard animator.allowedOrientations?.contains(orientation) ?? true else { return }
        guard animator.supportedOrientations.contains(orientation) else { return }
        animator.orientation = orientation
        delegate?.beginTransition(with: self)
    }
    
    public func updateInteractiveTransitionWithProgress(_ progress: CGFloat) {
        interactor?.update(progress)
    }
    
    public func finishInteractiveTransition() {
        interactor?.setCompletionSpeedForFinish()
        interactor?.finish()
    }
    
    public func cancelInteractiveTransition() {
        interactor?.setCompletionSpeedForCancel()
        interactor?.cancel()
    }
}

extension InteractiveTransitioner: TransitionAnimatorDelegate {
    public func transitionDidFinish(_ completed: Bool) {
        delegate?.finishedInteractiveTransition(completed)
    }
}
