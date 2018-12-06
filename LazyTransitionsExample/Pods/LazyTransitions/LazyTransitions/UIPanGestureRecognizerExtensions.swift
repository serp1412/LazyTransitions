//
//  UIPanGestureRecognizerExtensions.swift
//  LazyTransitions
//
//  Created by Serghei Catraniuc on 11/24/16.
//  Copyright © 2016 BeardWare. All rights reserved.
//

import Foundation

public enum UIPanGestureRecognizerDirection {
    case undefined
    case bottomToTop
    case topToBottom
    case rightToLeft
    case leftToRight
}

extension UIPanGestureRecognizer {
    public var direction: UIPanGestureRecognizerDirection {
        let velocity = self.velocity(in: view)
        let isVertical = abs(velocity.y) > abs(velocity.x)
        
        var direction: UIPanGestureRecognizerDirection
        
        if isVertical {
            direction = velocity.y > 0 ? .topToBottom : .bottomToTop
        } else {
            direction = velocity.x > 0 ? .leftToRight : .rightToLeft
        }
        
        return direction
    }
    
    public func isQuickSwipe(for orientation: TransitionOrientation) -> Bool {
        let velocity = self.velocity(in: view)
        return isQuickSwipeForVelocity(velocity, for: orientation)
    }
    
    private func isQuickSwipeForVelocity(_ velocity: CGPoint, for orientation: TransitionOrientation) -> Bool {
        switch orientation {
        case .unknown : return false
        case .topToBottom : return velocity.y > 1000
        case .bottomToTop : return velocity.y < -1000
        case .leftToRight : return velocity.x > 1000
        case .rightToLeft : return velocity.x < -1000
        }
    }
}

extension UIPanGestureRecognizer {
    typealias GestureHandlingTuple = (gesture: UIPanGestureRecognizer? , handle: (UIPanGestureRecognizer) -> ())
    fileprivate static var handlers = [GestureHandlingTuple]()
    
    public convenience init(gestureHandle: @escaping (UIPanGestureRecognizer) -> ()) {
        self.init()
        UIPanGestureRecognizer.cleanup()
        set(gestureHandle: gestureHandle)
    }
    
    public func set(gestureHandle: @escaping (UIPanGestureRecognizer) -> ()) {
        weak var weakSelf = self
        let tuple = (weakSelf, gestureHandle)
        UIPanGestureRecognizer.handlers.append(tuple)
        addTarget(self, action: #selector(handleGesture))
    }
    
    fileprivate static func cleanup() {
        handlers = handlers.filter { $0.0?.view != nil }
    }
    
    @objc private func handleGesture(_ gesture: UIPanGestureRecognizer) {
        let handleTuples = UIPanGestureRecognizer.handlers.filter{ $0.gesture === self }
        handleTuples.forEach { $0.handle(gesture)}
    }
}
