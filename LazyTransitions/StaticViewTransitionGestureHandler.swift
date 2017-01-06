//
//  StaticViewTransitionGestureHandler.swift
//  Wadi
//
//  Created by Serghei Catraniuc on 12/6/16.
//  Copyright © 2016 YOPESO. All rights reserved.
//

import Foundation

public class StaticViewTransitionGestureHandler: TransitionGestureHandler {
    public var shouldFinish: Bool = false
    public var didBegin: Bool = false
    public var inProgressTransitionOrientation = TransitionOrientation.unknown
    public weak var delegate: TransitionGestureHandlerDelegate?
    
    public init() {}
    
    public func didBegin(_ gesture: UIPanGestureRecognizer) {
        inProgressTransitionOrientation = gesture.direction.orientation
        didBegin = true
        delegate?.beginInteractiveTransition(with: inProgressTransitionOrientation)
    }
    
    public func didChange(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: gesture.view)
        let progress = calculateTransitionProgressWithTranslation(translation, on: gesture.view)
        shouldFinish = progress > progressThreshold
        delegate?.updateInteractiveTransitionWithProgress(progress)
    }
    
    public func calculateTransitionProgressWithTranslation(_ translation: CGPoint, on view: UIView?) -> Float {
        
        guard let view = view else { return 0 }
        
        let progress = TransitionProgressCalculator
            .progress(for: view,
                      withGestureTranslation: translation,
                      withTranslationOffset: .zero,
                      with: inProgressTransitionOrientation)
        
        return progress
    }
}

extension UIPanGestureRecognizerDirection {
    public var orientation: TransitionOrientation {
        switch self {
        case .left: return .rightToLeft
        case .right: return .leftToRight
        case .up: return .bottomToTop
        case .down: return .topToBottom
        default: return .unknown
        }
    }
}

extension UIPanGestureRecognizerDirection {
    public var isHorizontal: Bool {
        switch self {
        case .left, .right:
            return true
        default:
            return false
        }
    }
}
