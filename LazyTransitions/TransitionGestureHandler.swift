//
//  TransitionGestureHandler.swift
//  Wadi
//
//  Created by Serghei Catraniuc on 12/5/16.
//  Copyright © 2016 YOPESO. All rights reserved.
//

import Foundation

public protocol TransitionGestureHandlerDelegate: class {
    func beginInteractiveTransition(with orientation: TransitionOrientation)
    func updateInteractiveTransitionWithProgress(_ progress: Float)
    func finishInteractiveTransition()
    func cancelInteractiveTransition()
}

public protocol TransitionGestureHandler: class {
    weak var delegate: TransitionGestureHandlerDelegate? { get set }
    var shouldFinish: Bool { get }
    var didBegin: Bool { get set }
    var inProgressTransitionOrientation: TransitionOrientation { get }
    func handlePanGesture(_ gesture: UIPanGestureRecognizer)
    func didBegin(_ gesture: UIPanGestureRecognizer)
    func didChange(_ gesture: UIPanGestureRecognizer)
    func didEnd(_ gesture: UIPanGestureRecognizer)
    func didCancel(_ gesture: UIPanGestureRecognizer)
    func calculateTransitionProgressWithTranslation(_ translation: CGPoint, on view: UIView?) -> Float
}

public extension TransitionGestureHandler {
    func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
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
    
    func didBegin(_ gesture: UIPanGestureRecognizer) { }
    
    func didEnd(_ gesture: UIPanGestureRecognizer) {
        if shouldFinish || shouldTransitionByQuickSwipe(gesture) {
            delegate?.finishInteractiveTransition()
        } else {
            delegate?.cancelInteractiveTransition()
        }
        
        didBegin = false
    }
    
    func didCancel(_ gesture: UIPanGestureRecognizer) {
        delegate?.cancelInteractiveTransition()
        didBegin = false
    }
    
    func shouldTransitionByQuickSwipe(_ gesture: UIPanGestureRecognizer) -> Bool {
        if !didBegin { return false }
        
        return gesture.isQuickSwipe(for: inProgressTransitionOrientation)
    }
}
