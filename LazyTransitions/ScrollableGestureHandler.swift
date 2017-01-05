//
//  ScrollableGestureHandler.swift
//  Wadi
//
//  Created by Serghei Catraniuc on 12/6/16.
//  Copyright © 2016 YOPESO. All rights reserved.
//

import Foundation

class ScrollableGestureHandler: TransitionGestureHandler {
    var shouldFinish = false
    var didBegin = false
    var inProgressTransitionOrientation = TransitionOrientation.unknown
    weak var delegate: TransitionGestureHandlerDelegate?
    
    fileprivate weak var scrollable: Scrollable?
    fileprivate var translationOffset = CGPoint.zero
    
    init(scrollable: Scrollable) {
        self.scrollable = scrollable
        self.scrollable?.bounces = false
    }
    
    func didChange(_ gesture: UIPanGestureRecognizer) {
        guard scrollable != nil else {
            didBegin = false
            shouldFinish = false
            inProgressTransitionOrientation = .unknown
            return
        }
        
        handleTransitionGestureChanged(gesture)
        
        guard shouldBeginTransition else { return }
        
        handleTransitionGestureBegan(gesture)
    }
    
    func calculateTransitionProgressWithTranslation(_ translation: CGPoint, on view: UIView?) -> Float {
        guard let view = view else { return 0 }
        
        let progress = TransitionProgressCalculator
            .progress(for: view,
                      withGestureTranslation: translation,
                      withTranslationOffset: translationOffset,
                      with: inProgressTransitionOrientation)
        
        return progress
    }
    
    fileprivate func handleTransitionGestureBegan(_ gesture: UIPanGestureRecognizer) {
        let orientation = transitionOrientation(for: gesture)
        let translation = gesture.translation(in: gesture.view)
        translationOffset = translation;
        inProgressTransitionOrientation = orientation
        didBegin = true
        delegate?.beginInteractiveTransition(with: inProgressTransitionOrientation)
    }
    
    fileprivate func handleTransitionGestureChanged(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: gesture.view)
        let progress = calculateTransitionProgressWithTranslation(translation, on: gesture.view)
        shouldFinish = progress > progressThreshold
        delegate?.updateInteractiveTransitionWithProgress(progress)
    }
    
    fileprivate var shouldBeginTransition: Bool {
        if didBegin { return false }
        guard let scrollable = scrollable else { return false }
        
        if scrollable.isSomeWhereInVerticalMiddle && scrollable.isSomeWhereInHorizontalMiddle { return false }
        if !scrollable.scrollsHorizontally
            && scrollable.isSomeWhereInVerticalMiddle {
            return false
        }
        
        if !scrollable.scrollsVertically
            && scrollable.isSomeWhereInHorizontalMiddle {
            return false
        }
        
        return true
    }
    
    fileprivate func transitionOrientation(for gesture: UIPanGestureRecognizer) -> TransitionOrientation {
        guard let scrollable = scrollable else { return .topToBottom }
        
        if !scrollable.scrollsHorizontally {
            return scrollable.possibleVerticalOrientation
        }
        
        if !scrollable.scrollsVertically {
            return scrollable.possibleHorizontalOrientation
        }
        
        if scrollable.isSomeWhereInHorizontalMiddle {
            return scrollable.possibleVerticalOrientation
        }
        
        if scrollable.isSomeWhereInVerticalMiddle {
            return scrollable.possibleHorizontalOrientation
        }
        
        return gesture.direction.isHorizontal ?
            scrollable.possibleHorizontalOrientation :
            scrollable.possibleVerticalOrientation
    }
}
