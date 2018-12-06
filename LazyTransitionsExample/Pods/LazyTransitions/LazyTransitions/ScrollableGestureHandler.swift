//
//  ScrollableGestureHandler.swift
//  LazyTransitions
//
//  Created by Serghei Catraniuc on 12/6/16.
//  Copyright © 2016 BeardWare. All rights reserved.
//

import Foundation

public class ScrollableGestureHandler: TransitionGestureHandlerType {
    public var shouldFinish = false
    public var didBegin = false
    public var inProgressTransitionOrientation = TransitionOrientation.unknown
    public weak var delegate: TransitionGestureHandlerDelegate?
    
    fileprivate weak var scrollable: Scrollable?
    fileprivate var translationOffset = CGPoint.zero
    
    public init(scrollable: Scrollable) {
        self.scrollable = scrollable
        self.scrollable?.bounces = false
    }
    
    public func didChange(_ gesture: UIPanGestureRecognizer) {
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
    
    public func calculateTransitionProgressWithTranslation(_ translation: CGPoint, on view: UIView?) -> CGFloat {
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
        
        if scrollable.isSomewhereInVerticalMiddle && scrollable.isSomewhereInHorizontalMiddle { return false }
        if !scrollable.scrollsHorizontally
            && scrollable.isSomewhereInVerticalMiddle {
            return false
        }
        
        if !scrollable.scrollsVertically
            && scrollable.isSomewhereInHorizontalMiddle {
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
        
        if scrollable.isSomewhereInHorizontalMiddle {
            return scrollable.possibleVerticalOrientation
        }
        
        if scrollable.isSomewhereInVerticalMiddle {
            return scrollable.possibleHorizontalOrientation
        }
        
        return gesture.direction.isHorizontal ?
            scrollable.possibleHorizontalOrientation :
            scrollable.possibleVerticalOrientation
    }
}
