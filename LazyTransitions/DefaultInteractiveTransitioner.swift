//
//  DefaultInteractiveTransitioner.swift
//  Wadi
//
//  Created by Serghei Catraniuc on 11/30/16.
//  Copyright © 2016 YOPESO. All rights reserved.
//

import Foundation

class DefaultInteractiveTransitioner: InteractiveTransitioner {
    
    //MARK: Initializers
    
    required init(with gestureHandler: TransitionGestureHandler,
         with animator: TransitionAnimator = DefaultAnimator(orientation: .topToBottom),
         with interactor: TransitionInteractor = TransitionInteractor.default()) {
        self.gestureHandler = gestureHandler
        self.animator = animator
        self.animator.delegate = self
        self.gestureHandler.delegate = self
        self.interactor = interactor
    }
    
    //MARK: InteractiveTransitioner Protocol
    
    var gestureHandler: TransitionGestureHandler
    weak var delegate: TransitionerDelegate?
    var animator: TransitionAnimator
    var interactor: TransitionInteractor?
}

extension DefaultInteractiveTransitioner: TransitionGestureHandlerDelegate {
    func beginInteractiveTransition(with orientation: TransitionOrientation) {
        guard animator.allowedOrientations?.contains(orientation) ?? true else { return }
        guard animator.supportedOrientations.contains(orientation) else { return }
        animator.orientation = orientation
        delegate?.beginTransition(with: self)
    }
    
    func updateInteractiveTransitionWithProgress(_ progress: Float) {
        interactor?.update(CGFloat(progress))
    }
    
    func finishInteractiveTransition() {
        interactor?.setCompletionSpeedForFinish()
        interactor?.finish()
    }
    
    func cancelInteractiveTransition() {
        interactor?.setCompletionSpeedForCancel()
        interactor?.cancel()
    }
}

extension DefaultInteractiveTransitioner: TransitionAnimatorDelegate {
    func transitionDidFinish(_ completed: Bool) {
        delegate?.finishedInteractiveTransition(completed)
    }
}
