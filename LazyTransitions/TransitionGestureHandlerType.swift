//
//  TransitionGestureHandlerType.swift
//  LazyTransitions
//
//  Created by Serghei Catraniuc on 12/5/16.
//  Copyright © 2016 BeardWare. All rights reserved.
//

import Foundation

public protocol TransitionGestureHandlerDelegate: class {
    func beginInteractiveTransition(with orientation: TransitionOrientation)
    func updateInteractiveTransitionWithProgress(_ progress: CGFloat)
    func finishInteractiveTransition()
    func cancelInteractiveTransition()
}

public protocol TransitionGestureHandlerType: class {
    weak var delegate: TransitionGestureHandlerDelegate? { get set }
    var shouldFinish: Bool { get }
    var didBegin: Bool { get set }
    var inProgressTransitionOrientation: TransitionOrientation { get }
    func handlePanGesture(_ gesture: UIPanGestureRecognizer)
    func didBegin(_ gesture: UIPanGestureRecognizer)
    func didChange(_ gesture: UIPanGestureRecognizer)
    func didEnd(_ gesture: UIPanGestureRecognizer)
    func didCancel(_ gesture: UIPanGestureRecognizer)
    func calculateTransitionProgressWithTranslation(_ translation: CGPoint, on view: UIView?) -> CGFloat
}

extension TransitionGestureHandlerType {
    public func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .began:
            didBegin(gesture)
        case .changed:
            didChange(gesture)
        case .cancelled:
            didCancel(gesture)
        case .ended:
            didEnd(gesture)
        default: break
        }
    }
    
    public func didBegin(_ gesture: UIPanGestureRecognizer) { }
    
    public func didEnd(_ gesture: UIPanGestureRecognizer) {
        if shouldFinish || shouldTransitionByQuickSwipe(gesture) {
            delegate?.finishInteractiveTransition()
        } else {
            delegate?.cancelInteractiveTransition()
        }
        
        didBegin = false
    }
    
    public func didCancel(_ gesture: UIPanGestureRecognizer) {
        delegate?.cancelInteractiveTransition()
        didBegin = false
    }
    
    public func shouldTransitionByQuickSwipe(_ gesture: UIPanGestureRecognizer) -> Bool {
        if !didBegin { return false }
        
        return gesture.isQuickSwipe(for: inProgressTransitionOrientation)
    }
}
